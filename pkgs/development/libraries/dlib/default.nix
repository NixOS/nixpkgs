{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, openblas, libpng, libjpeg
, guiSupport ? false, libX11
}:

stdenv.mkDerivation rec {
  version = "19.6";
  name = "dlib-${version}";

  src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    rev ="v${version}";
    sha256 = "1nlx4z53jnk7wysaxrzbyyqb65m45rw4g1fagazl2jvwh1qn49ds";
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

