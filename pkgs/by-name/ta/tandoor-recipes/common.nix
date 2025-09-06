{ lib, fetchFromGitHub }:
rec {
  version = "2.1.2";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-FCCXzWaWjmsWidg1MgUIJtH+KN/gA1d7KBLRj3/1Fec=";
  };

  yarnHash = "sha256-vwPwJK+nGuhjJC5BdijAKOv7sgrdev63PWhuZXMD1E0=";

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
