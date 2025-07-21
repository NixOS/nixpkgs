{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "duckdb.yazi";
  version = "25.4.8-unstable-2025-05-29";

  src = fetchFromGitHub {
    owner = "wylie102";
    repo = "duckdb.yazi";
    rev = "3f8c8633d4b02d3099cddf9e892ca5469694ba22";
    hash = "sha256-XQM459V3HbPgXKgd9LnAIKRQOAaJPdZA/Tp91TSGHqY=";
  };

  meta = {
    description = "Yazi plugin that uses duckdb to preview data files";
    homepage = "https://github.com/wylie102/duckdb.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
