{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "phive";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "phar-io";
    repo = "phive";
    rev = finalAttrs.version;
    hash = "sha256-K/YZOGANcefjfdFY1XYEQknm0bPRorlRnNGC7dEegZ0=";
  };

  vendorHash = "sha256-0fJ+SyicvVONJ4FkOFTkBTekDAOjBfaLo0dZ2DYlGJU=";

  meta = {
    changelog = "https://github.com/phar-io/phive/releases/tag/${finalAttrs.version}";
    description = "Phar Installation and Verification Environment (PHIVE)";
    homepage = "https://github.com/phar-io/phive";
    license = lib.licenses.bsd3;
    mainProgram = "phive";
    maintainers = lib.teams.php.members;
  };
})
