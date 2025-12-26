{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "elm-git-install";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "robinheghan";
    repo = "elm-git-install";
    tag = finalAttrs.version;
    hash = "sha256-rWmfhAZ4JrmiLZ4N16OvMp6dtZSMHXBNpOsdW0SqRPU=";
  };

  npmDepsHash = "sha256-/oVW5gm1llA1+AXkzkjlqBEGLaMFyA+zc8HI9nt8Y0Q=";

  dontNpmBuild = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/robinheghan/elm-git-install/blob/${finalAttrs.version}/CHANGES.md";
    description = "Install private Elm packages from any git url";
    homepage = "https://github.com/robinheghan/elm-git-install";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pyrox0 ];
    mainProgram = "elm-git-install";
  };
})
