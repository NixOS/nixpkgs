{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline.yazi";
  version = "25.5.31-unstable-2025-06-12";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline.yazi";
    rev = "88bd1c58357d472fe7e8daf9904936771fc49795";
    hash = "sha256-RkQKZQAa5U9eMWk1Q0doueJZiuP4elUJ0dM1XKLSnDo=";
  };

  meta = {
    description = "Yazi plugin for customizing both header-line and status-line";
    homepage = "https://github.com/imsi32/yatline.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
