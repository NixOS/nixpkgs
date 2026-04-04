{ lib, fetchFromGitHub }:
rec {
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-tjVqHcDy+Ms1L3IuGo3aKDKcrHU22YvDE8QBEQ8Hybg=";
  };

  yarnHash = "sha256-yC8v/lYTL12YTJLX+/BrBLolzQ0O4kSZpcsduLHm65o=";

  meta = {
    homepage = "https://tandoor.dev/";
    changelog = "https://github.com/TandoorRecipes/recipes/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [
      jvanbruegge
      ryand56
    ];
  };
}
