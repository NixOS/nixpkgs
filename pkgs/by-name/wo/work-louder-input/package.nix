{
  lib,
  stdenvNoCC,
  fetchurl,
  _7zz,
  re-plistbuddy,
  versionCheckHook,
  writeShellScript,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "work-louder-input";
  version = "0.18.0";

  src = fetchurl {
    url = "https://github.com/worklouder/input-releases/releases/download/v${finalAttrs.version}/input-${finalAttrs.version}-arm64.dmg";
    hash = "sha512-wWqOccCNrV84/kedxHBZrvZ9nndWVHuzNaEAGEyOO/iCVMOkh1gixtAPexlZb/KVGjOsMwBX74lTH2vOaevJHQ==";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ _7zz ];

  sourceRoot = ".";

  unpackCmd = "7zz x -snld -xr'!*:com.apple.*' $curSrc";

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R input.app "$out/Applications"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = writeShellScript "version-check" ''
    ${lib.getExe' re-plistbuddy "PlistBuddy"} -c "Print :CFBundleShortVersionString" "$1"
  '';
  versionCheckProgramArg = [
    "${placeholder "out"}/Applications/input.app/Contents/Info.plist"
  ];
  doInstallCheck = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Keyboard configurator for Work Louder devices";
    homepage = "https://worklouder.cc/input";
    changelog = "https://github.com/worklouder/input-releases/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ pradyuman ];
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
