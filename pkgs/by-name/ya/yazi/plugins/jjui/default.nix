{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "jjui.yazi";
  version = "0-unstable-2026-01-17";

  src = fetchFromGitHub {
    owner = "Adda0";
    repo = "jjui.yazi";
    rev = "a41b2e17a4d256bc06868079efb375716e07cd28";
    hash = "sha256-r2XWSu0voQmQj6jI2Jh17FiNwbvQcEwM6LNDqX7qCOQ=";
  };

  meta = {
    description = "jjui plugin for yazi";
    homepage = "https://github.com/Adda0/jjui.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ adda ];
  };
}
