{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline-githead.yazi";
  version = "0-unstable-2025-05-31";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline-githead.yazi";
    rev = "f8f969e84c39ad4215334ea5012183a2a5a6160b";
    hash = "sha256-Cs8zSYtUfdCmKwIkJwQGyQNeSOmmpPvObCMnGm+32zg=";
  };

  meta = {
    description = "githead.yazi with yatline.yazi support";
    homepage = "https://github.com/imsi32/yatline-githead.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
