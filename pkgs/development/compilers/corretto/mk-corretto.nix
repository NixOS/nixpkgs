{
  majorVersion, # jdk wording is "featureVersion"
  jdk11,
  jdk17,
  jdk21,
  jdk25,
  lib,
  fetchurl,
  stdenv,
  gradle,
  nixpkgs-openjdk-updater,
  extraConfig ? [ ],
  rsync,
  runCommand,
  testers,
}:

# Each Corretto version is based on a corresponding OpenJDK version. So
# building Corretto is more or less the same as building OpenJDK. Hence, the
# Corretto derivation overrides the corresponding OpenJDK derivation in order
# to have access to all the version-specific fixes for the various OpenJDK
# builds. However, Corretto uses `gradle` as build tool (which in turn will
# invoke `make`). The configure/build phases are adapted as needed.

# The version scheme is different between OpenJDK & Corretto.
# See https://github.com/corretto/corretto-17/blob/release-17.0.8.8.1/build.gradle#L40
# "major.minor.security.build.revision"
let
  sourceFile = ./. + "/${majorVersion}/source.json";
  source = nixpkgs-openjdk-updater.openjdkSource {
    inherit sourceFile;
    featureVersionPrefix = majorVersion;
  };
  version = lib.removePrefix "refs/tags/" source.src.rev; # "17.0.8.8.1"
  jdk =
    {
      "11" = jdk11;
      "17" = jdk17;
      "21" = jdk21;
      "25" = jdk25;
    }
    .${majorVersion};
  is11 = majorVersion == "11";
  is17 = majorVersion == "17";
  is21 = majorVersion == "21";
  is25 = majorVersion == "25";
  pname = "corretto${majorVersion}";
in
jdk.overrideAttrs (
  finalAttrs: oldAttrs: {
    inherit pname version;
    inherit (source) src;

    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [
      jdk
      gradle
      rsync
    ];

    dontConfigure = true;

    patches =
      if is11 then
        (oldAttrs.patches or [ ])
        ++ [
          ./11/gradle8.patch
        ]
      else if is17 then
        # Corretto17 has incorporated this patch already so it fails to apply.
        # We thus skip it here.
        # See https://github.com/corretto/corretto-17/pull/158
        lib.remove (fetchurl {
          url = "https://git.alpinelinux.org/aports/plain/community/openjdk17/FixNullPtrCast.patch?id=41e78a067953e0b13d062d632bae6c4f8028d91c";
          sha256 = "sha256-LzmSew51+DyqqGyyMw2fbXeBluCiCYsS1nCjt9hX6zo=";
        }) (oldAttrs.patches or [ ])
        ++ [ ./17/gradle8.patch ]
      else if is21 then
        (oldAttrs.patches or [ ])
        ++ [
          ./21/gradle8.patch
        ]
      else if is25 then
        (oldAttrs.patches or [ ])
        ++ [
          # See patches in openjdk/generic.nix.
          ./25/remove_removal_of_wformat_during_test_compilation.patch
        ]
      else
        (oldAttrs.patches or [ ]);

    postPatch =
      let
        extra_config = builtins.concatStringsSep " " extraConfig;
        jdk_configure_flags = "'" + builtins.concatStringsSep "', '" oldAttrs.configureFlags + "'";
      in
      (oldAttrs.postPatch or "")
      + ''
        # The rpm/deb task definitions require a Gradle plugin which we don't
        # have and so the build fails. We'll simply empty them here because
        # they are not needed anyways. The directories are kept because Gradle
        # still expects them.
        rm -rf installers/linux/universal/{rpm,deb}/{*,.*}

        # These fixes are necessary as long as we use Gradle 9 to build
        # Corretto but upstream is not yet using it. I.e. as long as upstream
        # hasn't fixed compatibility with Gradle 9 issues.
        find /build/source/installers -type d -exec cp /build/source/version.txt {}/version.txt \;
        find /build/source/installers -name 'build.gradle' -exec sed -i '/fileMode =/d' {} \;
        for d in source pre-build; do
          # These subprojects (see settings.gradle) don't exist. Create them
          # here so that Gradle doesn't complain.
          mkdir /build/source/$d
          cp /build/source/version.txt /build/source/$d/version.txt
        done

        # `/usr/bin/rsync` is invoked to copy the source tree. We don't have that.
        for file in $(find installers -name "build.gradle"); do
          substituteInPlace $file --replace-warn "workingDir '/usr/bin'" "workingDir '.'"
        done

        # Prepend corresponding OpenJDK flags to Corretto's own configure flags.
        # This will provide us with the version-specific fixes (see
        # openjdk/generic.nix) while giving Corretto's flags precedence.
        # Note that the OpenJdK flags contain "--with-boot-jdk=..."!
        substituteInPlace build.gradle --replace-fail "correttoCommonFlags = [" "correttoCommonFlags = [${jdk_configure_flags} ,"
        # Finally, *append* nix-corretto-version specific flags.
        gradleFlagsArray+=(-Pcorretto.extra_config="${extra_config}")
      '';

    # since we dontConfigure, we must run this manually
    preBuild = "gradleConfigureHook";

    # The Linux installer is placed at linux/universal/tar whereas the MacOS
    # one is at mac/tar.
    gradleBuildTask =
      if stdenv.hostPlatform.isDarwin then
        ":installers:mac:tar:build"
      else
        ":installers:linux:universal:tar:packageBuildResults";

    postBuild = ''
      # Prepare for the installPhase so that it looks like if a normal
      # OpenJDK had been built.
      dir=build/jdkImageName/images
      mkdir -p $dir
      file=$(find ./installers -name 'amazon-corretto-${version}*.tar.gz')
      tar -xzf $file -C $dir
      mv $dir/amazon-corretto-* $dir/jdk
      chmod +x $dir/jdk/bin/*
    ''
    + oldAttrs.postBuild or "";

    installPhase = oldAttrs.installPhase + ''
      # The installPhase will place everything in $out/lib/openjdk and
      # reference through symlinks. We don't rewrite the installPhase but at
      # least move the folder to convey that this is not OpenJDK anymore.
      mv $out/lib/openjdk $out/lib/corretto
      ln -s $out/lib/corretto $out/lib/openjdk
    '';

    passthru =
      let
        pkg = finalAttrs.finalPackage;
      in
      oldAttrs.passthru
      // {
        tests = {
          version = testers.testVersion { package = pkg; };
          vendor = runCommand "${pname}-vendor" { nativeBuildInputs = [ pkg ]; } ''
            output=$(${pkg.meta.mainProgram} -XshowSettings:properties -version 2>&1 | grep vendor)
            grep -Fq "java.vendor = Amazon.com Inc." - <<< "$output" && touch $out
          '';
          compiler = runCommand "${pname}-compiler" { nativeBuildInputs = [ pkg ]; } ''
            cat << EOF  > Main.java
            class Main {
                public static void main(String[] args) {
                    System.out.println("Hello, World!");
                }
            }
            EOF
            ${pkg}/bin/javac Main.java
            ${pkg}/bin/java Main | grep -q "Hello, World!" && touch $out
          '';
        };
      };

    meta = oldAttrs.meta // {
      homepage = "https://aws.amazon.com/corretto";
      license = lib.licenses.gpl2Only;
      description = "Amazon's distribution of OpenJDK";
      maintainers = with lib.maintainers; [ rollf ];
      platforms = lib.platforms.linux;
      teams = [ ];
    };
  }
)
