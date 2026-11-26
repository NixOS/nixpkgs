{
  buildDartApplication,
  fetchFromGitHub,
  lib,
}:

buildDartApplication (finalAttrs: {
  pname = "unsure";
  version = "0-unstable-2026-11-14";

  strictDeps = true;

  src = fetchFromGitHub {
    owner = "filiph";
    repo = "unsure";
    rev = "7925917d47a1682ff0794c2bef5f392b99e7b347";
    hash = "sha256-Tt78IgyZPcC/XAMOe/Ya4LZN1giiCQFLojJUN3WGAt8=";
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
