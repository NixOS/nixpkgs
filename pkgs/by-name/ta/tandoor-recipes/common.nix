{ lib, fetchFromGitHub }:
rec {
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-ezjeUOlbVoPWfUBs865ixBKet3U6O7UwfvqJY4v1hwQ=";
  };

  yarnHash = "sha256-1p79Bdsn6KDApYKz9BAwrA97svbB8ub+Wl49MTIumW8=";

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
