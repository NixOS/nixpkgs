{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject (finalAttrs: {
  pname = "deployer";
  version = "7.3.3";

  src = fetchFromGitHub {
    owner = "deployphp";
    repo = "deployer";
    rev = "v${finalAttrs.version}^";
    hash = "sha256-zvK7NwIACAhWN/7D8lVY1Bv8x6xKAp/L826SovQhDYg=";
  };

  vendorHash = "sha256-BDq2uryNWC31AEAEZJL9zGaAPbhXZ6hmfpsnr4wlixE=";

  meta = {
    description = "The PHP deployment tool with support for popular frameworks out of the box";
    homepage = "https://deployer.org/";
    license = lib.licenses.mit;
    mainProgram = "dep";
    maintainers = lib.teams.php.members;
  };
})
