{ jdk
, version
, src
, lib
, stdenv
, autoconf
, gradle
, rsync
, runCommand
, testers
, which
, xcbuild
, zip
, darwin
, cups
, iconv
, libnet
, libzip
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
  #
  xnu = darwin.xnu.overrideAttrs (finalAttrs: oldAttrs: {
    postInstall = oldAttrs.postInstall + ''
      # The `xnu` derivation is used as `--with-sysroot` in the build phase.
      # correto assumes certain paths to be present in the sysroot.
      # https://github.com/corretto/corretto-11/blob/22d3ba74941d48a775ef44c69e1a8e92d099cb8e/make/gensrc/Gensrc-jdk.hotspot.agent.gmk#L51
      ln -s $out $out/usr
    '';
  });
in
jdk.overrideAttrs (finalAttrs: oldAttrs: {
  inherit pname version src;
  name = "${pname}-${version}";

  # env.NIX_DEBUG = "7";
  #
  env.NIX_CFLAGS_COMPILE = builtins.concatStringsSep " " [
    "-Wno-implicit-int-float-conversion"
    "-Wno-deprecated-non-prototype"
    "-Wno-deprecated-builtins"
  ];

  nativeBuildInputs = oldAttrs.nativeBuildInputs
                      ++ [ jdk gradle rsync ]
                      ++ lib.optionals stdenv.isDarwin [
                        zip
                        autoconf
                        which
                        xcbuild
                        darwin.xattr
                        darwin.stubs.setfile
                        cups
                        darwin.libobjc
                        libnet
                        libzip

                        darwin.apple_sdk.frameworks.Accelerate
                        darwin.apple_sdk.frameworks.ApplicationServices
                        darwin.apple_sdk.frameworks.AudioToolbox
                        darwin.apple_sdk.frameworks.Carbon
                        darwin.apple_sdk.frameworks.Cocoa
                        darwin.apple_sdk.frameworks.CoreFoundation
                        darwin.apple_sdk.frameworks.CoreServices
                        darwin.apple_sdk.frameworks.ExceptionHandling
                        darwin.apple_sdk.frameworks.Foundation
                        darwin.apple_sdk.frameworks.JavaRuntimeSupport
                        darwin.apple_sdk.frameworks.JavaVM
                        darwin.apple_sdk.frameworks.Kerberos
                        darwin.apple_sdk.frameworks.Security
                        darwin.apple_sdk.frameworks.SystemConfiguration

                        iconv
                        xnu
                      ];

  postPatch = ''
    # The rpm/deb task definitions require a Gradle plugin which we don't
    # have and so the build fails. We'll simply remove them here because
    # they are not needed anyways.
    rm -rf installers/linux/universal/{rpm,deb}

    # `/usr/bin/rsync` is invoked to copy the source tree. We don't have that.
    for file in $(find installers -name "build.gradle"); do
      substituteInPlace $file --replace-fail "workingDir '/usr/bin'" "workingDir '.'"
    done

    # Remove the "sanity check" present in make/autoconf/basic.m4
    for file in $(find make/autoconf -name "basic.m4"); do
      substituteInPlace $file --replace-fail "if test ! -f \"\$SYSROOT/System/Library/Frameworks/Foundation.framework/Headers/Foundation.h\"; then" "if false; then"
    done
  '';

  buildPhase =
    let
      # The Linux installer is placed at linux/universal/tar whereas the MacOS
      # one is at mac/tar.
      task =
        if stdenv.isDarwin then
          ":installers:mac:tar:packaging"
        else ":installers:linux:universal:tar:packageBuildResults";
      extraConfig = builtins.concatStringsSep " " [
        # Fix "configure: error: Invalid SDK or SYSROOT path, dependent framework headers not found"
        "--with-sysroot=${xnu}"
        # Fix error: 'new' file not found
        "--disable-precompiled-headers"
        # Fix missing cups
        "--with-cups=${cups.dev}"
      ];

    in
    ''
      runHook preBuild

      # Fix "Failed to load native library 'libnative-platform.dylib' for Mac
      # OS X ..." because $HOME/.gradle is not accessible.
      export GRADLE_USER_HOME=$(mktemp -d)

      gradle -Pcorretto.extra_config="${extraConfig}" --console=plain --no-daemon ${task}

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
