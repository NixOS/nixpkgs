{ lib, fetchFromGitHub, php }:

php.buildComposerProject (finalAttrs: {
  pname = "deployer";
  version = "7.3.1";

  src = fetchFromGitHub {
    owner = "deployphp";
    repo = "deployer";
    rev = "v${finalAttrs.version}^";
    hash = "sha256-bsJcozAVvRXUNdxRdBh5SB6qESUSXkkPeEWF50IiboQ=";
  };

  vendorHash = "sha256-KoFH6UYIeO+GMQVmnoJ19snPXX7yOU6FJ+0S3SqkbVo=";

  meta = with lib; {
    description = "A deployment tool for PHP";
    license = licenses.mit;
    homepage = "https://deployer.org/";
    mainProgram = "dep";
    maintainers = teams.php.members;
  };
})
