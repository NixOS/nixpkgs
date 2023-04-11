{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "phive";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "phar-io";
    repo = "phive";
    rev = finalAttrs.version;
    hash = "sha256-K/YZOGANcefjfdFY1XYEQknm0bPRorlRnNGC7dEegZ0=";
  };

  vendorHash = "sha256-gGC241GGOvzGYR+Rpn+IUiB6oVk/pphnjPObpqTg5dc=";

  meta = with lib; {
    changelog = "https://github.com/phar-io/phive/releases/tag/${finalAttrs.version}";
    description = "The Phar Installation and Verification Environment (PHIVE)";
    homepage = "https://github.com/phar-io/phive";
    license = licenses.bsd3;
    maintainers = teams.php.members;
  };
})
