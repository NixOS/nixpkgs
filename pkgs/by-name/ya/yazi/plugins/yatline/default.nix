{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline.yazi";
  version = "0-unstable-2025-04-11";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline.yazi";
    rev = "90e0284b22f922e7e024c403e7e596359e3aa2a0";
    hash = "sha256-99HcvxylfPf5MlAnDOi/eg3C1XwzKnGz/vmMTBnSm/o=";
  };

  meta = {
    description = "Yazi plugin for customizing both header-line and status-line.";
    homepage = "https://github.com/imsi32/yatline.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
