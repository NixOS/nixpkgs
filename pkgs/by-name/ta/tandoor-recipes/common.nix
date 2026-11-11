{ lib, fetchFromGitHub }:
rec {
  version = "2.7.2";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-t07kcoouqRgvvjrpwOzYuUx0y66M5vmIXaQA8k8tayk=";
  };

  yarnHash = "sha256-udK+Pc8yiEl+u7yoYOg5W5w1n00UOSwdcF0DZhAkviI=";

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
