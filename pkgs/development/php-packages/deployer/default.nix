{
  lib,
  fetchFromGitHub,
  php,
}:

php.buildComposerProject2 (finalAttrs: {
  pname = "deployer";
  version = "7.4.0";

  src = fetchFromGitHub {
    owner = "deployphp";
    repo = "deployer";
    rev = "v${finalAttrs.version}^";
    hash = "sha256-nSrW4o0Tb8H056AAjjMzbsAVvWY2z1pdWmPFZDpDr1k=";
  };

  vendorHash = "sha256-APzJQTeSNbWvF/RtfNL7XuXIY0Xa0VNbJdSggFicpSQ=";

  meta = {
    changelog = "https://github.com/deployphp/deployer/releases/tag/v${finalAttrs.version}";
    description = "PHP deployment tool with support for popular frameworks out of the box";
    homepage = "https://deployer.org/";
    license = lib.licenses.mit;
    mainProgram = "dep";
    maintainers = lib.teams.php.members;
  };
})
