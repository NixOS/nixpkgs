{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "smart-filter.yazi";
  version = "25.12.29-unstable-2025-12-29";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "517619af126f25f3da096ff156ce46b561b54be3";
    hash = "sha256-j7fsUmx2nK4Tyj5KCamcCmfs99K6duV+okf8NvzccsI=";
  };

  meta = {
    description = "Yazi plugin that makes filters smarter";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
