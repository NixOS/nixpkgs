{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phive";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "phar-io";
    repo = "phive";
    tag = finalAttrs.version;
    hash = "sha256-dv9v1KCLNheFmrRQ7cID5WFvoiH0OWVPWSrN023dEqA=";
  };

  vendorHash = "sha256-H1QJ+ML0tbZzEBKknP0GHhUhw+ujiIH/QNmEgA2zSmM=";

  meta = {
    changelog = "https://github.com/phar-io/phive/releases/tag/${finalAttrs.version}";
    description = "Phar Installation and Verification Environment (PHIVE)";
    homepage = "https://github.com/phar-io/phive";
    license = lib.licenses.bsd3;
    mainProgram = "phive";
    teams = [ lib.teams.php ];
  };
})
