{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "smart-paste.yazi";
  version = "0-unstable-2025-04-27";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "864a0210d9ba1e8eb925160c2e2a25342031d8d3";
    hash = "sha256-m3709h7/AHJAtoJ3ebDA40c77D+5dCycpecprjVqj/k=";
  };

  meta = {
    description = "Previewing archive contents with smart-filter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
