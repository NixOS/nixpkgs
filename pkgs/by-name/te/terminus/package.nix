{
  lib,
  fetchFromGitHub,
  php,
}:
php.buildComposerProject2 (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;
  pname = "terminus";
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "pantheon-systems";
    repo = "terminus";
    tag = finalAttrs.version;
    hash = "sha256-3+bNCHOkWqw2a2ZteIRpPNkZ1e/zttPPhA2QRLuvYzE=";
  };

  vendorHash = "sha256-rMzUiL3UO2RYZ8Rzu5war6iIBwdGBV+BvM75ygrRJHA=";

  meta = {
    description = "Standalone utility for performing operations on the Pantheon Platform";
    homepage = "https://github.com/pantheon-systems/terminus";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      OulipianSummer
    ];
    platforms = php.meta.platforms;
    mainProgram = "terminus";
  };
})
