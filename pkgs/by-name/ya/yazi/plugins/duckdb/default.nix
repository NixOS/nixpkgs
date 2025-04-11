{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "duckdb.yazi";
  version = "25.4.8-unstable-2025-04-08";

  src = fetchFromGitHub {
    owner = "wylie102";
    repo = "duckdb.yazi";
    rev = "eaa748c62e24f593104569d2dc15d50b1d48497b";
    hash = "sha256-snQ+n7n+71mqAsdzrXcI2v7Bg0trrbiHv3mIAxldqlc=";
  };

  meta = {
    description = "Yazi plugin that uses duckdb to preview data files.";
    homepage = "https://github.com/wylie102/duckdb.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
