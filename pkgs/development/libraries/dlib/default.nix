{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, libpng, libjpeg
, guiSupport ? false, libX11
}:

stdenv.mkDerivation rec {
  version = "19.13";
  name = "dlib-${version}";

  src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    rev ="v${version}";
    sha256 = "11ia4pd2lm2s9hzwrdvimj3r2qcnvjdp3g4fry2j1a6z9f99zvz3";
  };

  postPatch = ''
    rm -rf dlib/external
  '';

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libpng libjpeg ] ++ lib.optional guiSupport libX11;

  meta = with stdenv.lib; {
    description = "A general purpose cross-platform C++ machine learning library";
    homepage = http://www.dlib.net;
    license = licenses.boost;
    maintainers = with maintainers; [ christopherpoole ma27 ];
    platforms = platforms.linux;
  };
}
