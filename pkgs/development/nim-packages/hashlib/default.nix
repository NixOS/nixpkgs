{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "hashlib";
  version = "1.0.1";
  src = fetchFromGitHub {
    owner = "khchen";
    repo = pname;
    rev = "84e0247555e4488594975900401baaf5bbbfb531";
    hash = "sha256-nWNThelCh0LPVU7ryZgS/23hRRvJDVL2xWbQibb+zN0=";
  };
  meta = src.meta // {
    description = "Hash Library for Nim";
    maintainers = with lib.maintainers; [ ehmry ];
    license = lib.licenses.mit;
  };
}
