{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline-githead.yazi";
  version = "0-unstable-2026-01-31";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline-githead.yazi";
    rev = "929e52cd6ff9ef0130756260ee5f0af69ce5debe";
    hash = "sha256-1r7AY0Yzr32YZl2g74ylx+1vGoNg04PMkDXnaB0X+lk=";
  };

  meta = {
    description = "githead.yazi with yatline.yazi support";
    homepage = "https://github.com/imsi32/yatline-githead.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
