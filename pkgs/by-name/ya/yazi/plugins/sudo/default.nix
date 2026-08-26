{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "sudo.yazi";
  version = "0-unstable-2026-08-23";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = "sudo.yazi";
    rev = "be3670f3eae8c565e541d65e5f8f292f2e4f2398";
    hash = "sha256-GNhoRnEKfA6otuXal87JWLW1bUW4Ago94BbQQ1ae3zA=";
  };

  meta = {
    description = "Call `sudo` in yazi";
    homepage = "https://github.com/TD-Sky/sudo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
