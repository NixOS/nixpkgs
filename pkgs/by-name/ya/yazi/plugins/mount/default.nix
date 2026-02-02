{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mount.yazi";
  version = "25.12.29-unstable-2026-01-26";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "0c95a0dac882e652f70c6fbc79655658c0cb6e74";
    hash = "sha256-DwHTpEIuING9cajq+O61OmHR93/tpKqgU+cM0//5TZ8=";
  };

  meta = {
    description = "Mount manager for Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
