{
  lib,
  fetchFromGitHub,
  php,
}:
php.buildComposerProject2 {
  __structuredAttrs = true;
  strictDeps = true;
  pname = "terminus";
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "pantheon-systems";
    repo = "terminus";
    tag = "4.3.3";
    hash = "sha256-3+bNCHOkWqw2a2ZteIRpPNkZ1e/zttPPhA2QRLuvYzE=";
  };

  vendorHash = "sha256-rMzUiL3UO2RYZ8Rzu5war6iIBwdGBV+BvM75ygrRJHA=";

  meta = {
    description = "A standalone utility for performing operations on the Pantheon Platform";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      OulipianSummer
    ];
    platforms = php.meta.platforms;
    mainProgram = "terminus";
  };
}
