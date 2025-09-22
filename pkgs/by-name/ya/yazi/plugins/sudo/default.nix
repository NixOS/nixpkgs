{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "sudo.yazi";
  version = "0-unstable-2025-09-17";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = "sudo.yazi";
    rev = "f35afcbe183c6017038f64b03fd42eef413efa33";
    hash = "sha256-pgYHKLKqtpxRDaT+FyVFuh7tBJe7lUfy2LBJMPAtSqA=";
  };

  meta = {
    description = "Call `sudo` in yazi";
    homepage = "https://github.com/TD-Sky/sudo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
