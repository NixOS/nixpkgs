{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "bypass.yazi";
  version = "25.3.2-unstable-2025-05-11";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "bypass.yazi";
    rev = "85b5e9624a9eaa14c70b17b873209a2054f4062a";
    hash = "sha256-2fblXb2uE6tq9goZKzMFgiEUVsx+uaRLyIq9BzTM8KA=";
  };

  meta = {
    description = "Yazi plugin for skipping directories with only a single sub-directory.";
    homepage = "https://github.com/Rolv-Apneseth/bypass.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
