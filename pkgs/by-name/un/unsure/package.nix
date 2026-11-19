{
  buildDartApplication,
  fetchFromGitHub,
  lib,
}:

buildDartApplication (finalAttrs: {
  pname = "unsure";
  version = "0.5.0-unstable-2026-11-12";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "filiph";
    repo = "unsure";
    rev = "9e2da5ef67fd084891e1962185643064e4ca0f8b";
    hash = "sha256-gDzNaYFvulK2Fdz86SWYMxFvD+edHK1MJosFvtVkeNE=";
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
    changelog = "https://github.com/filiph/unsure/blob/${finalAttrs.src.rev}/CHANGELOG.md";
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
})
