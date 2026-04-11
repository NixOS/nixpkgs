{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "mount.yazi";
  version = "25.12.29-unstable-2026-01-31";

  src = fetchFromGitHub {
    owner = "yazi-rs";
    repo = "plugins";
    rev = "d078b01ecbdb0f85f6ea8836a851c6bf72f9f865";
    hash = "sha256-aPe1AntPE76xq0VA/4FtBtRXmj+tfDjdMlQ9B9MkM+U=";
  };

  meta = {
    description = "Mount manager for Yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
