{ lib, buildPythonPackage, fetchFromGitHub }:

buildPythonPackage rec {
  version = "2.0.1";
  pname = "crc32c";

  src = fetchFromGitHub {
    owner = "ICRAR";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vyac7pchh083h5qdjwhhacfq77frkrq1bjzsn51qv1vwcdrpnrf";
  };

  meta = {
    description = "Python software implementation and hardware API of CRC32C checksum algorithm";
    homepage = "https://github.com/ICRAR/crc32c";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
