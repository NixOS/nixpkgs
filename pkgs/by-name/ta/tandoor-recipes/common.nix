{ lib, fetchFromGitHub }:
rec {
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    tag = version;
    hash = "sha256-tFnfuRYg9lq7hveGZqpRVHNaXxS6BUs88/BHnUXe4mA=";
  };

  yarnHash = "sha256-6+GmYibzujV1vE0FqMctGscRkrendpvczDdMK++qtTU=";

  meta = {
    homepage = "https://tandoor.dev/";
    changelog = "https://github.com/TandoorRecipes/recipes/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
