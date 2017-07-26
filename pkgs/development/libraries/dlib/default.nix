{ stdenv, fetchFromGitHub, cmake, xlibsWrapper }:

stdenv.mkDerivation rec {
  version = "19.4";
  name = "dlib-${version}";

  src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    rev ="v${version}";
    sha256 = "0zqa36i4s5i7n6284sp22qrhm3k37n9vqmpz068nm02vj9h0a2j4";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A general purpose cross-platform C++ machine learning library";
    homepage = http://www.dlib.net;
    license = licenses.boost;
    maintainers = with maintainers; [ christopherpoole ];
    platforms = platforms.all;
  };
}

