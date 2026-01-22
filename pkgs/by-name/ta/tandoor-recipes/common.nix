{ lib, fetchFromGitHub }:
rec {
  version = "2.3.6";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-DWPy4wse9sAr/xmZuNRXy4kYTD5elGx9QiXmJKrw860=";
  };

  yarnHash = "sha256-++Si9U9Ouz9LpeemtqzIiQIpuhbSJkruKlVR1WSgQfo=";

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
