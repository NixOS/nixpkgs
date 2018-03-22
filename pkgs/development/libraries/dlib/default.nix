{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, openblas, libpng, libjpeg
, guiSupport ? false, libX11
}:

stdenv.mkDerivation rec {
  version = "19.10";
  name = "dlib-${version}";

  src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    rev ="v${version}";
    sha256 = "0sgxblf4n33b8wgblyblmrkwydvy1yh7fzll1b6c4zgkz675w0m5";
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

