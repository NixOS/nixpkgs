{ stdenv, fetchurl, cmake }:
let version = "3.0.0";
in stdenv.mkDerivation rec {
  name = "tinyxml-2-${version}";
  src = fetchurl {
    url = "https://github.com/leethomason/tinyxml2/archive/${version}.tar.gz";
    sha256 = "0ispg7ngkry8vhzzawbq42y8gkj53xjipkycw0rkhh487ras32hj";
  };

  nativeBuildInputs = [ cmake ];
}
