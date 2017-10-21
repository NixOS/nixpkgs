{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  name = "tinyxml-2-${version}";
  version = "4.0.1";

  src = fetchFromGitHub {
    repo = "tinyxml2";
    owner = "leethomason";
    rev = version;
    sha256 = "1a0skfi8rzk53qcxbv88qlvhlqzvsvg4hm20dnx4zw7vrn6anr9y";
  };

  nativeBuildInputs = [ cmake ];

  meta = {
    description = "A simple, small, efficient, C++ XML parser";
    homepage = http://www.grinninglizard.com/tinyxml2/index.html;
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.zlib;
  };
}
