{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "sudo.yazi";
  version = "0-unstable-2025-11-05";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = "sudo.yazi";
    rev = "86205aa8044f10b02471be1087f3381bbadc967e";
    hash = "sha256-mpQLij+Sg88RarCC+0u7JfZ2EqcX4gB7jvy8bfBt90w=";
  };

  meta = {
    description = "Call `sudo` in yazi";
    homepage = "https://github.com/TD-Sky/sudo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
