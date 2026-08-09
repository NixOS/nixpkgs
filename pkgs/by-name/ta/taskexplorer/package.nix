{
  lib,
  stdenvNoCC,
  fetchzip,
  makeWrapper,
  nix-update-script,
  testers,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "taskexplorer";
  version = "2.1.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchzip {
    url = "https://github.com/objective-see/TaskExplorer/releases/download/v${finalAttrs.version}/TaskExplorer_${finalAttrs.version}.zip";
    hash = "sha256-hwqV06vE3LyZW8AnnatTOcapCqEuHp/EM5dV+xhhvno=";

    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/Applications"
    cp -R TaskExplorer.app "$out/Applications/TaskExplorer.app"

    runHook postInstall
  '';

  postInstall = ''
    mkdir -p $out/bin
    makeWrapper $out/Applications/TaskExplorer.app/Contents/MacOS/TaskExplorer $out/bin/taskexplorer
  '';

  dontFixup = true; # Preserve upstream's notarized app bundle and system extension signature.

  passthru = {
    updateScript = nix-update-script { };

    tests = {
      help = testers.runCommand {
        name = "taskexplorer-help-test";
        buildInputs = [ finalAttrs.finalPackage ];
        script = ''
          # Capture both stdout and stderr, and use `|| true` to suppress the 255 exit code
          # which occurs because of the wrong help exit code imlementation in taskexplorer
          # Fix when this is merged: https://github.com/objective-see/TaskExplorer/pull/9
          output=$(taskexplorer -h 2>&1 || true)

          echo "$output" | grep -F "TASKEXPLORER USAGE:"

          touch $out
        '';
      };
    };
  };

  meta = {
    mainProgram = "taskexplorer";
    description = "Tool to explore all the running tasks (processes)";
    longDescription = ''
      Explore all the tasks (processes) running on your Mac with TaskExplorer.
      Quickly see a task's signature status, loaded dylibs, open files, network connection, and much more!
    '';
    homepage = "https://objective-see.org/products/taskexplorer.html";
    downloadPage = "https://github.com/objective-see/TaskExplorer/releases";
    changelog = "https://github.com/objective-see/TaskExplorer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.darwin;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    identifiers = {
      cpeParts = {
        vendor = "objective-see";
        product = "taskexplorer";
        version = finalAttrs.version;
        target_sw = "macos";
      };
      purlParts = {
        type = "github";
        namespace = "objective-see";
        name = "taskexplorer";
        version = finalAttrs.version;
      };
    };
    maintainers = with lib.maintainers; [
      KristijanZic
    ];
  };
})
