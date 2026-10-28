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

    cmdlineTools="$ANDROID_HOME/${package.path}"
    if [ -f "$cmdlineTools/lib/sdkmanager-classpath.jar" ]; then
      # Wrap sdkmanager script
      wrapProgram "$cmdlineTools/bin/sdkmanager" \
        --prefix PATH : ${lib.makeBinPath [ pkgs.jdk17 ]} \
        --add-flags "--sdk_root=$ANDROID_HOME"
    else
      # Since cmdline-tools 23.0, sdkmanager is a shim around the `android` launcher,
      # which downloads an unpinned Android CLI into ~/.android at runtime.
      # The Java SdkManagerCli is still shipped, so invoke it directly instead.
      rm "$cmdlineTools/bin/sdkmanager"
      makeWrapper ${pkgs.jdk17}/bin/java "$cmdlineTools/bin/sdkmanager" \
        --prefix PATH : ${lib.makeBinPath [ pkgs.jdk17 ]} \
        --add-flags "-Dcom.android.sdkmanager.toolsdir=$cmdlineTools" \
        --add-flags '$JAVA_OPTS $SDKMANAGER_OPTS' \
        --add-flags "-classpath $cmdlineTools/lib/sdklib/tools.sdklib.jar:$cmdlineTools/lib/avdmanager-classpath.jar" \
        --add-flags "com.android.sdklib.tool.sdkmanager.SdkManagerCli" \
        --add-flags "--sdk_root=$ANDROID_HOME"
    fi

    # Patch all script shebangs
    patchShebangs "$ANDROID_HOME/${package.path}/bin"

    cd "$ANDROID_HOME"
    ${postInstall}
  '';

  inherit meta;
}
