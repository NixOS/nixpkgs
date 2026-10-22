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
    export ANDROID_HOME="$out/libexec/android-sdk"

    # Wrap all scripts that require JAVA_HOME.
    # Use ANDROID_SDK_ROOT as legacy compatibility but the "correct" way is ANDROID_HOME nowadays (2026+).
    find "$ANDROID_HOME/${package.path}/bin" -maxdepth 1 -type f -executable | while read program; do
      if grep -q "JAVA_HOME" "$program"; then
        wrapProgram "$program"  --prefix PATH : ${pkgs.jdk17}/bin \
          --prefix ANDROID_HOME : "$ANDROID_HOME" \
          --prefix ANDROID_SDK_ROOT : "$ANDROID_HOME"
      fi
    done

    # Wrap sdkmanager script
    wrapProgram "$ANDROID_HOME/${package.path}/bin/sdkmanager" \
      --prefix PATH : ${lib.makeBinPath [ pkgs.jdk17 ]} \
      --add-flags "--sdk_root=$ANDROID_HOME"

    # Patch all script shebangs
    patchShebangs "$ANDROID_HOME/${package.path}/bin"

    cd "$ANDROID_HOME"
    ${postInstall}
  '';

  inherit meta;
}
