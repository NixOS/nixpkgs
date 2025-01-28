{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "phive";
  version = "0.15.3";

  src = fetchFromGitHub {
    owner = "phar-io";
    repo = "phive";
    tag = finalAttrs.version;
    hash = "sha256-6vNhmIDE3kwZGMrDnGNGVV6/lb32Yb3ooWDYOC7SUcs=";
  };

  vendorHash = "sha256-wNqQfVRm4kEWpYfdo8HBESh0L4cXPrTlHnBI79b1Al0=";

  meta = {
    changelog = "https://github.com/phar-io/phive/releases/tag/${finalAttrs.version}";
    description = "Phar Installation and Verification Environment (PHIVE)";
    homepage = "https://github.com/phar-io/phive";
    license = lib.licenses.bsd3;
    mainProgram = "phive";
    maintainers = lib.teams.php.members;
  };
})
