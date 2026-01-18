{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-optimize-level-2";
  version = "0.3.4-unstable-2022-04-05";

  src = fetchFromGitHub {
    owner = "mdgriffith";
    repo = "elm-optimize-level-2";
    rev = "46b0975d5349260d2492c2ee532af7230f5af407";
    hash = "sha256-l93qrkGAmGdZdj9j97MEUiprQT7gFqtL71rb5zOJwk4=";
  };

  npmDepsHash = "sha256-4noXdD/KUNridPlwQ2cqVcAaUoP5XUwZhpbEPHVBeqo=";

  npmFlags = [ "--ignore-scripts" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    changelog = "https://github.com/mdgriffith/elm-optimize-level-2/blob/master/CHANGELOG.md";
    description = "A second level of optimization for the Javascript that the Elm Compiler produces.";
    homepage = "https://github.com/mdgriffith/elm-optimize-level-2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "elm-optimize-level-2";
  };
})
