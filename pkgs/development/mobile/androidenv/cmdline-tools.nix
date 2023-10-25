{deployAndroidPackage, lib, package, autoPatchelfHook, makeWrapper, os, pkgs, pkgsi686Linux, stdenv, cmdLineToolsVersion, postInstall}:

deployAndroidPackage {
  name = "androidsdk";
  inherit package os;
  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];

  patchInstructions = ''
    ${lib.optionalString (os == "linux") ''
      # Auto patch all binaries
      autoPatchelf .
    ''}

    # Strip double dots from the root path
    export ANDROID_SDK_ROOT="$out/libexec/android-sdk"

    # Wrap all scripts that require JAVA_HOME
    find $ANDROID_SDK_ROOT/cmdline-tools/${cmdLineToolsVersion}/bin -maxdepth 1 -type f -executable | while read program; do
      if grep -q "JAVA_HOME" $program; then
        wrapProgram $program  --prefix PATH : ${pkgs.jdk11}/bin \
          --prefix ANDROID_SDK_ROOT : $ANDROID_SDK_ROOT
      fi
    done

    # Wrap sdkmanager script
    wrapProgram $ANDROID_SDK_ROOT/cmdline-tools/${cmdLineToolsVersion}/bin/sdkmanager \
      --prefix PATH : ${lib.makeBinPath [ pkgs.jdk11 ]} \
      --add-flags "--sdk_root=$ANDROID_SDK_ROOT"

    # Patch all script shebangs
    patchShebangs $ANDROID_SDK_ROOT/cmdline-tools/${cmdLineToolsVersion}/bin

    cd $ANDROID_SDK_ROOT
    ${postInstall}
  '';

  meta.license = lib.licenses.unfree;
}
