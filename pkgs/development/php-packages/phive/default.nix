{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "phive";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "phar-io";
    repo = "phive";
    rev = finalAttrs.version;
    hash = "sha256-6vNhmIDE3kwZGMrDnGNGVV6/lb32Yb3ooWDYOC7SUcs=";
  };

  vendorHash = "sha256-iBNH4n4AVE47CYmwO6s6WBAuRe7JzzvoNruYfVbxPck=";

  meta = {
    changelog = "https://github.com/phar-io/phive/releases/tag/${finalAttrs.version}";
    description = "Phar Installation and Verification Environment (PHIVE)";
    homepage = "https://github.com/phar-io/phive";
    license = lib.licenses.bsd3;
    mainProgram = "phive";
    maintainers = lib.teams.php.members;
  };
})
