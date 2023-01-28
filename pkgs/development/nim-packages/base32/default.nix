{ lib, buildNimPackage, fetchFromGitHub }:

buildNimPackage rec {
  pname = "base32";
  version = "0.1.3";
  src = fetchFromGitHub {
    owner = "OpenSystemsLab";
    repo = "${pname}.nim";
    rev = version;
    hash = "sha256-BsDly13xsY2bu4N9LGHB0OGej/JhAx3B01TDdF0M8Jk=";
  };
  doCheck = true;
  meta = src.meta // {
    description = "Base32 library for Nim";
    maintainers = with lib.maintainers; [ ehmry ];
    license = lib.licenses.mit;
  };
}
