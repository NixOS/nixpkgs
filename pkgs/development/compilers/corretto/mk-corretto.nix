{ jdk
, version
, src
, lib
, stdenv
, gradle
, extraConfig ? [ ]
, rsync
, runCommand
, testers
}:

# Each Corretto version is based on a corresponding OpenJDK version. So
# building Corretto is more or less the same as building OpenJDK. Hence, the
# Corretto derivation overrides the corresponding OpenJDK derivation in order
# to have access to all the version-specific fixes for the various OpenJDK
# builds. However, Corretto uses `gradle` as build tool (which in turn will
# invoke `make`). The configure/build phases are adapted as needed.

let
  pname = "corretto";
  # The version scheme is different between OpenJDK & Corretto.
  # See https://github.com/corretto/corretto-17/blob/release-17.0.8.8.1/build.gradle#L40
  # "major.minor.security.build.revision"
in
jdk.overrideAttrs (finalAttrs: oldAttrs: {
  inherit pname version src;
  name = "${pname}-${version}";

  nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ jdk gradle rsync ];

  dontConfigure = true;

  postPatch = ''
    # The rpm/deb task definitions require a Gradle plugin which we don't
    # have and so the build fails. We'll simply remove them here because
    # they are not needed anyways.
    rm -rf installers/linux/universal/{rpm,deb}

    # `/usr/bin/rsync` is invoked to copy the source tree. We don't have that.
    for file in $(find installers -name "build.gradle"); do
      substituteInPlace $file --replace-warn "workingDir '/usr/bin'" "workingDir '.'"
    done
  '';


  buildPhase =
    let
      # The Linux installer is placed at linux/universal/tar whereas the MacOS
      # one is at mac/tar.
      task =
        if stdenv.isDarwin then
          ":installers:mac:tar:packageBuildResults"
        else ":installers:linux:universal:tar:packageBuildResults";
      extra_config = builtins.concatStringsSep " " extraConfig;
    in
    ''
      runHook preBuild

      # Corretto's actual built is triggered via `gradle`.
      gradle -Pcorretto.extra_config="${extra_config}" --console=plain --no-daemon ${task}

      # Prepare for the installPhase so that it looks like if a normal
      # OpenJDK had been built.
      dir=build/jdkImageName/images
      mkdir -p $dir
      file=$(find ./installers -name 'amazon-corretto-${version}*.tar.gz')
      tar -xzf $file -C $dir
      mv $dir/amazon-corretto-* $dir/jdk

      runHook postBuild
    '';

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
    oldAttrs.passthru // {
      tests = {
        version = testers.testVersion {
          package = pkg;
        };
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


  # Some of the OpenJDK derivation set their `pos` by hand. We need to
  # overwrite this in order to point to Corretto, not OpenJDK.
  pos = __curPos;
  meta = with lib; oldAttrs.meta // {
    homepage = "https://aws.amazon.com/corretto";
    license = licenses.gpl2Only;
    description = "Amazon's distribution of OpenJDK";
    maintainers = with maintainers; [ rollf ];
  };
})
