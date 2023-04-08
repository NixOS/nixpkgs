{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  version = "2.2.post0";
  pname = "crc32c";

  src = fetchFromGitHub {
    owner = "ICRAR";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-0FgNOVpgJTxRALuufZ7Dt1TwuX+zqw35yCq8kmq4RTc=";
  };

  meta = {
    description = "Python software implementation and hardware API of CRC32C checksum algorithm";
    homepage = "https://github.com/ICRAR/crc32c";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
