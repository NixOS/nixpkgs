{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "duckdb.yazi";
  version = "25.4.8-unstable-2025-04-20";

  src = fetchFromGitHub {
    owner = "wylie102";
    repo = "duckdb.yazi";
    rev = "6259e2d26236854b966ebc71d28de0397ddbe4d8";
    hash = "sha256-9DMqE/pihp4xT6Mo2xr51JJjudMRAesxD5JqQ4WXiM4=";
  };

  meta = {
    description = "Yazi plugin that uses duckdb to preview data files";
    homepage = "https://github.com/wylie102/duckdb.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
