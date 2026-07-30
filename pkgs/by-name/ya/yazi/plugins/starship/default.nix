{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "starship.yazi";
  version = "0-unstable-2026-06-14";

  src = fetchFromGitHub {
    owner = "Rolv-Apneseth";
    repo = "starship.yazi";
    rev = "159eaba5b5052bf78ff6cfbfe4e527b946818c82";
    hash = "sha256-I21to4cxlszRpsb58cvsmwX7VglQBSJC0rrsFIltzC8=";
  };

  meta = {
    description = "Starship prompt plugin for yazi";
    homepage = "https://github.com/Rolv-Apneseth/starship.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
