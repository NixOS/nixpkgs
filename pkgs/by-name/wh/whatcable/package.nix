{
  fetchzip,
  lib,
  nix-update-script,
  re-plistbuddy,
  stdenvNoCC,
  versionCheckHook,
  writeShellScript,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "whatcable";
  version = "1.1.9";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/darrylmorley/whatcable/releases/download/v${finalAttrs.version}/WhatCable.zip";
    hash = "sha256-0taHQE4aUJrbRdWXZZyHfJ+2EzpEiXpsj8HWg04lgXg=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications/WhatCable.app" "$out/bin"
    cp -R . "$out/Applications/WhatCable.app"
    ln -s "$out/Applications/WhatCable.app/Contents/Helpers/whatcable" "$out/bin/whatcable"

    runHook postInstall
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgram = writeShellScript "whatcable-version-check" ''
    ${lib.getExe' re-plistbuddy "PlistBuddy"} -c "Print :CFBundleShortVersionString" "$1"
  '';
  versionCheckProgramArg = [ "${placeholder "out"}/Applications/WhatCable.app/Contents/Info.plist" ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "macOS menu bar app that explains USB-C cable capabilities";
    homepage = "https://whatcable.uk";
    changelog = "https://github.com/darrylmorley/whatcable/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tyceherrman ];
    mainProgram = "whatcable";
    platforms = [ "aarch64-darwin" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
})
