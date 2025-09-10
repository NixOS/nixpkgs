{ lib, fetchFromGitHub }:
rec {
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-lgy6NLaVsQ0WbK6ODjoQR57XGT5d19b68n/8FYIJUTY=";
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
