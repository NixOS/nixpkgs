{
  lib,
  stdenvNoCC,
  fetchurl,
  unzip,
  nix-update-script,
  runCommand,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "taskexplorer";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/objective-see/TaskExplorer/releases/download/v${finalAttrs.version}/TaskExplorer_${finalAttrs.version}.zip";
    hash = "sha256-v1CfFMq9raqBvDUJ0ZW4ZG7iA866FauibSbGuIJCLM0=";
  };

  nativeBuildInputs = [ unzip ];

  sourceRoot = ".";

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/Applications
    cp -R TaskExplorer.app $out/Applications/
    runHook postInstall
  '';

  passthru = {
    updateScript = nix-update-script { };
    tests.has-app = runCommand "taskexplorer-has-app" { } ''
      test -d "${finalAttrs.finalPackage}/Applications/TaskExplorer.app"
      test -x "${finalAttrs.finalPackage}/Applications/TaskExplorer.app/Contents/MacOS/TaskExplorer"
      touch $out
    '';
  };

  meta = {
    description = "macOS task and process monitor with VirusTotal integration";
    homepage = "https://objective-see.org/products/taskexplorer.html";
    changelog = "https://github.com/objective-see/TaskExplorer/releases/tag/v${finalAttrs.version}";
    downloadPage = "https://github.com/objective-see/TaskExplorer/releases";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ kaynetik ];
    platforms = [
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "TaskExplorer";
  };
})
