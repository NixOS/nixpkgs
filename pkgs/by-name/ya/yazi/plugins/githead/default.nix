{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "githead.yazi";
  version = "0-unstable-2026-01-26";

  src = fetchFromGitHub {
    owner = "llanosrocas";
    repo = "githead.yazi";
    rev = "317d09f728928943f0af72ff6ce31ea335351202";
    hash = "sha256-o2EnQYOxp5bWn0eLn0sCUXcbtu6tbO9pdUdoquFCTVw=";
  };

  meta = {
    description = "Git status header for yazi inspired by powerlevel10k ";
    homepage = "https://github.com/llanosrocas/githead.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
