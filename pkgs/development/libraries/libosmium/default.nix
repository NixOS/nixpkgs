{ stdenv, fetchFromGitHub, cmake, protozero, expat, zlib, bzip2, boost }:

stdenv.mkDerivation rec {
  pname = "libosmium";
  version = "2.15.6";

  src = fetchFromGitHub {
    owner = "osmcode";
    repo = "libosmium";
    rev = "v${version}";
    sha256 = "0rqy18bbakp41f44y5id9ixh0ar2dby46z17p4115z8k1vv9znq2";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ protozero zlib bzip2 expat boost ];

  doCheck = true;

  meta = with stdenv.lib; {
    description = "Fast and flexible C++ library for working with OpenStreetMap data";
    homepage = "https://osmcode.org/libosmium/";
    license = licenses.boost;
    maintainers = with maintainers; [ das-g ];
  };
}
