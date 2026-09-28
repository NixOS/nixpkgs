{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "sudo.yazi";
  version = "0-unstable-2026-08-30";

  src = fetchFromGitHub {
    owner = "TD-Sky";
    repo = "sudo.yazi";
    rev = "e70796a3961a55ae0cfaa056a563fb931e8b96db";
    hash = "sha256-gJgEVHJYjTOBUkUEyIMqmfuY4FP803cOU2VSHlM2+I4=";
  };

  meta = {
    description = "Call `sudo` in yazi";
    homepage = "https://github.com/TD-Sky/sudo.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
