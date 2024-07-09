{ lib, stdenv, fetchFromGitHub, cmake, qtbase }:

stdenv.mkDerivation rec {
  version = "0.9.0";
  pname = "qjson";

  src = fetchFromGitHub {
    owner = "flavio";
    repo = "qjson";
    rev = version;
    sha256 = "1f4wnxzx0qdmxzc7hqk28m0sva7z9p9xmxm6aifvjlp0ha6pmfxs";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ qtbase ];
  dontWrapQtApps = true;

  meta = with lib; {
    description = "Lightweight data-interchange format";
    homepage = "https://qjson.sourceforge.net/";
    license = licenses.lgpl21;
  };
}
