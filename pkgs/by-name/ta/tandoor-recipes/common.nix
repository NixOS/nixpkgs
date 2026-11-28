{ lib, fetchFromGitHub }:
rec {
  version = "2.7.8";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-054e5dVFgW0U3AqraOVr/ytjbK/41WnJlNG5PnQpBHI=";
  };

  yarnHash = "sha256-Y3eCaVusnVIK6zLY59HNq3k7V0NE6hUuS7gMGBGGpe8=";

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
