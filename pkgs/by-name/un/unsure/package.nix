{
  buildDartApplication,
  dart,
  fetchFromGitHub,
  lib,
  runCommand,
  testers,
  unsure,
  writeText,
}:

buildDartApplication rec {
  pname = "unsure";
  version = "0.4.0-unstable-2025-04-15";

  src = fetchFromGitHub {
    owner = "filiph";
    repo = "unsure";
    rev = "123712482b7053974cbef9ffa7ba46c1cdfb765f";
    hash = "sha256-rn10vy6l12ToiqO4vGVT4N7WNlj6PY/r+xVzjmYqILw=";
  };

  pubspecLock = lib.importJSON ./pubspec.lock.json;

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    [[ "$("$out/bin/unsure" "4~6 * 1~2" | head --lines=2)" == "$(printf '\n\t%s' '5~11')" ]]

    runHook postInstallCheck
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    changelog = "https://github.com/filiph/unsure/blob/${src.rev}/CHANGELOG.md";
    description = "Calculate with numbers you’re not sure about";
    downloadPage = "https://github.com/filiph/unsure";
    homepage = "https://filiph.github.io/unsure";
    license = lib.licenses.mit;
    mainProgram = "unsure";
    maintainers = [
      lib.maintainers.l0b0
      lib.maintainers.rksm
    ];
  };
}
