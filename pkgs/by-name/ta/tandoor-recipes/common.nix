{ lib, fetchFromGitHub }:
rec {
  version = "2.6.6";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-aRc9fh9O2ZI+9ngKraD3AnkOMPuPVt8evheJ0YvZETE=";
  };

  yarnHash = "sha256-Un5pHocZZrXajY3AGfqV1kjT9twE8B93rwoJMi4CILg=";

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
