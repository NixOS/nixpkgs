{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  version = "1.0.0";
  name = "Vc-${version}";

  src = fetchFromGitHub {
    owner = "VcDevel";
    repo = "Vc";
    rev = version;
    sha256 = "014li9kcbbxinh9r1nngdzspjzs2nxwslcknd950msjkqgnjhz4r";
  };

  nativeBuildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library for multiprecision complex arithmetic with exact rounding";
    homepage = https://github.com/VcDevel/Vc;
    license = licenses.bsd3;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
