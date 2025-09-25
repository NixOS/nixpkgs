{ lib, fetchFromGitHub }:
rec {
  version = "2.2.5";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-N6d5T11fOAtPKAV/tqTWGdwMkWNY8rPpWT2TBSc0ybc=";
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
