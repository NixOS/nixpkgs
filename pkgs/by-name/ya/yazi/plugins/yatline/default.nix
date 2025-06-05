{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline.yazi";
  version = "0-unstable-2025-05-31";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline.yazi";
    rev = "4872af0da53023358154c8233ab698581de5b2b2";
    hash = "sha256-7uk8QXAlck0/4bynPdh/m7Os2ayW1UXbELmusPqRmf4=";
  };

  meta = {
    description = "Yazi plugin for customizing both header-line and status-line";
    homepage = "https://github.com/imsi32/yatline.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
