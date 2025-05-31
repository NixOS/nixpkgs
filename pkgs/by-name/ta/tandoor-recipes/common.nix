{ lib, fetchFromGitHub }:
rec {
  version = "1.5.32";

  src = fetchFromGitHub {
    owner = "TandoorRecipes";
    repo = "recipes";
    rev = version;
    hash = "sha256-CNlst4bpvRSOPABg85k9xltbrZhs5MQLfJr+t7l7hhI=";
  };

  yarnHash = "sha256-CFPofExwhvto6FVBXdsEY/uZaVKPkWaSdfqkEV7KY70=";

  meta = {
    homepage = "https://tandoor.dev/";
    changelog = "https://github.com/TandoorRecipes/recipes/releases/tag/${version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ jvanbruegge ];
  };
}
