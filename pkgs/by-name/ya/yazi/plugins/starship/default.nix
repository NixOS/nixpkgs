{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "starship.yazi";
  version = "0-unstable-2026-08-17";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "ea92cf49380466f07231c952b409831e6afd2156";
    hash = "sha256-Jvoc/7YaOOppu8K2lJaVgiuBIyanRHHjEA6ZvnrFtiQ=";
  };

  meta = {
    description = "Starship prompt plugin for yazi";
    homepage = "https://github.com/Rolv-Apneseth/starship.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
