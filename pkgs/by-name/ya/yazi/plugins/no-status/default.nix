{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "no-status.yazi";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "4dc7f1b6458c2578f4494f10d468c68c1082214f";
    hash = "sha256-BSAOkL4H4LVMbTRFv4kzGGRpLgtKkfNTEsDH2EQ219Q=";
  };

  meta = {
    description = "Remove the status bar";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
