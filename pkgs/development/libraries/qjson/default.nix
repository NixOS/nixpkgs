{ stdenv, fetchFromGitHub, cmake, qt4 }:

stdenv.mkDerivation rec {
  version = "0.9.0";
  pname = "qjson";

  src = fetchFromGitHub {
    owner = "flavio";
    repo = "qjson";
    rev = version;
    sha256 = "1f4wnxzx0qdmxzc7hqk28m0sva7z9p9xmxm6aifvjlp0ha6pmfxs";
  };

  buildInputs = [ cmake qt4 ];

  meta = with stdenv.lib; {
    description = "Lightweight data-interchange format";
    homepage = "http://qjson.sourceforge.net/";
    license = licenses.lgpl21;
    inherit (qt4.meta) platforms;
  };
}
