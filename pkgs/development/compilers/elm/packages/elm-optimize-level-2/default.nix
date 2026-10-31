{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-optimize-level-2";
  version = "0.4.0-unstable-2026-05-12";

  src = fetchFromGitHub {
    owner = "mdgriffith";
    repo = "elm-optimize-level-2";
    rev = "72bce44dc892dbb003c16fbc1551f5bf8e967296";
    hash = "sha256-PAQSR/Oe/Sl54wmTG51zrFdF2pidlzf0Dy7s/c4D1vc=";
  };

  npmDepsHash = "sha256-Tqw5YhNdJpZcLeG8Ttsn70Bojl7EJy1lRcY57eyPLfQ=";

  npmFlags = [ "--ignore-scripts" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    changelog = "https://github.com/mdgriffith/elm-optimize-level-2/blob/master/CHANGELOG.md";
    description = "A second level of optimization for the Javascript that the Elm Compiler produces.";
    homepage = "https://github.com/mdgriffith/elm-optimize-level-2";
    license = lib.licenses.bsd3;
    maintainers = [ ];
    mainProgram = "elm-optimize-level-2";
  };
})
