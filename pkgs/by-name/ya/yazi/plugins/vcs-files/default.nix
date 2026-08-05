{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "vcs-files.yazi";
  version = "0-unstable-2026-07-26";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "4c63ed34bae678b0dfaae44c33bf3fbb5fdda5a6";
    hash = "sha256-XakVwNsH/OUCHftW8kTL/VNmVnY/S9xjpMXI79GXZPA=";
  };

  meta = {
    description = "Show Git file changes in Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
