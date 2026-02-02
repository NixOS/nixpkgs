{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "yatline-githead.yazi";
  version = "0-unstable-2026-01-30";

  src = fetchFromGitHub {
    owner = "imsi32";
    repo = "yatline-githead.yazi";
    rev = "25a068d78838e463a7c34f3674a6f3b986756968";
    hash = "sha256-1BrqMwFff3wH+RntYSQkeuRZiBMdgK5v1c9h+QQ8XF8=";
  };

  meta = {
    description = "githead.yazi with yatline.yazi support";
    homepage = "https://github.com/imsi32/yatline-githead.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
