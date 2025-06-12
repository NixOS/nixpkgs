{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline.yazi";
  version = "0-unstable-2025-06-11";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline.yazi";
    rev = "73bce63ffb454ea108a96f316e2a8c2e16a35262";
    hash = "sha256-pIaqnxEGKiWvtFZJm0e7GSbbIc2qaTCB+czHLcVuVzY=";
  };

  meta = {
    description = "Yazi plugin for customizing both header-line and status-line";
    homepage = "https://github.com/imsi32/yatline.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
