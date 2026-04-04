{ lib, fetchFromGitHub }:
rec {
  version = "2.6.4";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-PPx7rdJREh8qVHTk3a5j1lw3OwHXejravMGBak4u8b8=";
  };

  yarnHash = "sha256-9Oxp4C0iRaqsQG1e0DEdfUUAfSuZo/fiuQO0ofSJEXY=";

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
