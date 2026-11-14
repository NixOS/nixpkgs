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
  version = "1.5.0";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchzip {
    url = "https://github.com/darrylmorley/whatcable/releases/download/v${finalAttrs.version}/WhatCable.zip";
    hash = "sha256-iiUeQSYFOwJYv3LtVygBTkA/00r4r72XlpypScMCpLM=";
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

  nativeInstallCheckInputs = [
    versionCheckHook
    re-plistbuddy
  ];
  versionCheckProgram = writeShellScript "whatcable-version-check" ''
    ${lib.getExe' re-plistbuddy "PlistBuddy"} -c "Print :CFBundleShortVersionString" "$1"
  '';
  versionCheckProgramArg = [ "${placeholder "out"}/Applications/WhatCable.app/Contents/Info.plist" ];
  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    app="$out/Applications/WhatCable.app"
    executable=$(PlistBuddy -c 'Print :CFBundleExecutable' "$app/Contents/Info.plist")
    test -n "$executable"
    test -x "$app/Contents/MacOS/$executable"
    test -x "$app/Contents/Helpers/whatcable"
    test -L "$out/bin/whatcable"
    test "$(readlink "$out/bin/whatcable")" = "$app/Contents/Helpers/whatcable"

    # Execute a disposable copy outside the app bundle so macOS does not add
    # protected com.apple.macl metadata to the output. Keep the plist and Swift
    # resource bundles next to it: the CLI uses them for its version and help.
    mkdir cli-test
    cp "$out/bin/whatcable" cli-test/whatcable
    cp "$app/Contents/Info.plist" cli-test/
    cp -R "$app/Contents/Resources/"*.bundle cli-test/

    # These modes exit before hardware probing or launching the GUI.
    cliVersion=$(cli-test/whatcable --version)
    test "$cliVersion" = "$version"
    cli-test/whatcable --help > help.txt
    grep -F 'Usage: whatcable [options]' help.txt

    runHook postInstallCheck
  '';

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
