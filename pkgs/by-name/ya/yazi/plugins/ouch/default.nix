{
  lib,
  fetchFromGitHub,
  mkYaziPlugin,
}:
mkYaziPlugin {
  pname = "ouch.yazi";
  version = "0-unstable-2025-04-09";

  src = fetchFromGitHub {
    owner = "ndtoan96";
    repo = "ouch.yazi";
    rev = "73b7842bbccb12f15e1af54b8b06fc88f5efe82d";
    hash = "sha256-pdnQB9NSqCndqbeJLeSg2og2vBDg5zKx8EKWKVixqTM=";
  };

  meta = {
    description = "A Yazi plugin to preview archives.";
    homepage = "https://github.com/ndtoan96/ouch.yazi";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ khaneliman ];
  };
}
