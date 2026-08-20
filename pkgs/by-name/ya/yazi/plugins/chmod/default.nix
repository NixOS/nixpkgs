{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "chmod.yazi";
  version = "0-unstable-2026-08-19";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "213f300c234499e580b139e18321f7ce989d0bae";
    hash = "sha256-tpIaEus7E9ELs+GBNBEklzADtjaPETuxYtzZqQhwMCI=";
  };

  meta = {
    description = "Execute chmod on the selected files to change their mode";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
