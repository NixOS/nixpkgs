<<<<<<< HEAD
{deployAndroidPackage, lib, package, autoPatchelfHook, makeWrapper, os, pkgs, pkgsi686Linux, stdenv, postInstall}:
=======
{deployAndroidPackage, lib, package, autoPatchelfHook, makeWrapper, os, pkgs, pkgsi686Linux, stdenv, cmdLineToolsVersion, postInstall}:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    find $ANDROID_SDK_ROOT/${package.path}/bin -maxdepth 1 -type f -executable | while read program; do
=======
    find $ANDROID_SDK_ROOT/cmdline-tools/${cmdLineToolsVersion}/bin -maxdepth 1 -type f -executable | while read program; do
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      if grep -q "JAVA_HOME" $program; then
        wrapProgram $program  --prefix PATH : ${pkgs.jdk11}/bin \
          --prefix ANDROID_SDK_ROOT : $ANDROID_SDK_ROOT
      fi
    done

    # Wrap sdkmanager script
<<<<<<< HEAD
    wrapProgram $ANDROID_SDK_ROOT/${package.path}/bin/sdkmanager \
=======
    wrapProgram $ANDROID_SDK_ROOT/cmdline-tools/${cmdLineToolsVersion}/bin/sdkmanager \
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
      --prefix PATH : ${lib.makeBinPath [ pkgs.jdk11 ]} \
      --add-flags "--sdk_root=$ANDROID_SDK_ROOT"

    # Patch all script shebangs
<<<<<<< HEAD
    patchShebangs $ANDROID_SDK_ROOT/${package.path}/bin
=======
    patchShebangs $ANDROID_SDK_ROOT/cmdline-tools/${cmdLineToolsVersion}/bin
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    cd $ANDROID_SDK_ROOT
    ${postInstall}
  '';

  meta.license = lib.licenses.unfree;
}
