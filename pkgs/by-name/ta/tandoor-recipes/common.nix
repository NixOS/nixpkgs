{ lib, fetchFromGitHub }:
rec {
  version = "2.5.3";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-R8G6cuepHSrbB5rtyl6CunxD6dGI7kxEliLggIfPKlM=";
  };

  yarnHash = "sha256-gwATGCCd1Am7gOcQiLlelwiZYyC3PKs8CGEFxQOePMo=";

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
