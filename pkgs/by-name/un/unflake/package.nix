{
  lib,
  stdenv,
  fetchFromGitea,
  nix-update-script,
  python3,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "unflake";
  version = "0.2";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "goldstein";
    repo = "unflake";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GR41KcXYzcXJQZIhfRgGFCn8SNdMpYDLsquDYgf3vTc=";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p $out/bin
    echo '#!${lib.getExe python3}' > $out/bin/unflake
    tail -n +2 ./unflake.py >> $out/bin/unflake
    chmod +x $out/bin/unflake

    runHook postBuild
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An alternative dependency resolver & runtime for Nix flakes";
    homepage = "https://codeberg.org/goldstein/unflake";
    changelog = "https://codeberg.org/goldstein/unflake/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      soispha
      GoldsteinE
    ];
    mainProgram = "unflake";
  };
})
