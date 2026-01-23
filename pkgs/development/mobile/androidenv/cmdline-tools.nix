{
  deployAndroidPackage,
  lib,
  package,
  autoPatchelfHook,
  makeWrapper,
  os,
  arch,
  pkgs,
  stdenv,
  postInstall,
  meta,
}:

deployAndroidPackage {
  name = "androidsdk";
  inherit package os arch;
  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  patchInstructions = ''
    ${lib.optionalString (os == "linux") ''
      # Auto patch all binaries
      autoPatchelf .
    ''}

    # Strip double dots from the root path
    export ANDROID_SDK_ROOT="$out/libexec/android-sdk"

    # Wrap all scripts that require JAVA_HOME
    find $ANDROID_SDK_ROOT/${package.path}/bin -maxdepth 1 -type f -executable | while read program; do
      if grep -q "JAVA_HOME" $program; then
        wrapProgram $program  --prefix PATH : ${pkgs.jdk17}/bin \
          --prefix ANDROID_SDK_ROOT : $ANDROID_SDK_ROOT
      fi
    done

    # Wrap sdkmanager script
    wrapProgram $ANDROID_SDK_ROOT/${package.path}/bin/sdkmanager \
      --prefix PATH : ${lib.makeBinPath [ pkgs.jdk17 ]} \
      --add-flags "--sdk_root=$ANDROID_SDK_ROOT"

    # Patch all script shebangs
    patchShebangs $ANDROID_SDK_ROOT/${package.path}/bin

    cd $ANDROID_SDK_ROOT
    ${postInstall}
  '';

  inherit meta;
}
