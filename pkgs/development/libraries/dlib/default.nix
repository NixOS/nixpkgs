{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, openblas, libpng, libjpeg
, guiSupport ? false, libX11
}:

stdenv.mkDerivation rec {
  version = "19.9";
  name = "dlib-${version}";

  src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    rev ="v${version}";
    sha256 = "0lc54r928j9dg7f2wn25m887z24d31wrc14v2hn6aknp1z084lrc";
  };

  postPatch = ''
    rm -rf dlib/external
  '';

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ openblas libpng libjpeg ] ++ lib.optional guiSupport libX11;

  meta = with stdenv.lib; {
    description = "A general purpose cross-platform C++ machine learning library";
    homepage = http://www.dlib.net;
    license = licenses.boost;
    maintainers = with maintainers; [ christopherpoole ];
    platforms = platforms.all;
  };
}

