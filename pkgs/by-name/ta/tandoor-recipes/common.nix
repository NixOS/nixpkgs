{ lib, fetchFromGitHub }:
rec {
  version = "2.6.13";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-7620qMp3Trg2be51CP0LKas/1egk3Rmo+aaMp0pe83k=";
  };

  yarnHash = "sha256-EpmFGyuWZeqzdi8wPX7ABjfJKWP8r5qqpdfNKdOFiso=";

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
