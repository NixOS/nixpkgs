{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "zoom.yazi";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "4dc7f1b6458c2578f4494f10d468c68c1082214f";
    hash = "sha256-BSAOkL4H4LVMbTRFv4kzGGRpLgtKkfNTEsDH2EQ219Q=";
  };

  meta = {
    description = "Enlarge or shrink the preview image of a file, which is useful for magnifying small files for viewing";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ saadndm ];
  };
}
