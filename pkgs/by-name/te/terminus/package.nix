{
  fetchFromGitHub,
  lib,
  php,
}:

php.buildComposerProject2 rec {
  __structuredAttrs = true;

  pname = "terminus";
  version = "4.3.3";

  src = fetchFromGitHub {
    owner = "pantheon-systems";
    repo = "terminus";
    tag = version;
    hash = "sha256-3+bNCHOkWqw2a2ZteIRpPNkZ1e/zttPPhA2QRLuvYzE=";
  };

  vendorHash = "sha256-rMzUiL3UO2RYZ8Rzu5war6iIBwdGBV+BvM75ygrRJHA=";

  meta = {
    changelog = "https://github.com/pantheon-systems/terminus/releases/tag/${version}";
    description = "A command line interface for Pantheon";
    homepage = "https://github.com/pantheon-systems/terminus";
    license = lib.licenses.mit;
    longDescription = ''
      Terminus is a command-line interface that exposes site information and
      controls for sites hosted on Pantheon. It enables scripting
      common operations, managing sites, environments, users and
      organizations, and running Drush or WP-CLI commands remotely or in
      local SFTP environments.
    '';
    maintainers = with lib.maintainers; [ opdavies ];
    inherit (php.meta) platforms;
    mainProgram = "terminus";
  };
}
