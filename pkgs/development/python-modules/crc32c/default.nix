{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  version = "2.0";
  pname = "crc32c";

  src = fetchFromGitHub {
    owner = "ICRAR";
    repo = pname;
    rev = "v${version}";
    sha256 = "15x1sj23n50qdjmi8mjq5wgf5jfn1yv78vjc59wplvl0s50w2dnk";
  };

  meta = {
    description = "Python software implementation and hardware API of CRC32C checksum algorithm";
    homepage = "https://github.com/ICRAR/crc32c";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
