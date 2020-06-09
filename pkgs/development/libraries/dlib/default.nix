{ stdenv, lib, fetchFromGitHub, cmake, pkgconfig, libpng, libjpeg
, guiSupport ? false, libX11

  # see http://dlib.net/compile.html
, avxSupport ? true
, cudaSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "dlib";
  version = "19.20";

  src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    rev ="v${version}";
    sha256 = "10b5hrprlls0nhljx18ys8cms7bgqirvhxlx6gbvbprbi6q16f9r";
  };

  postPatch = ''
    rm -rf dlib/external
  '';

  cmakeFlags = [ 
    "-DUSE_DLIB_USE_CUDA=${if cudaSupport then "1" else "0"}"
    "-DUSE_AVX_INSTRUCTIONS=${if avxSupport then "yes" else "no"}" ];

  enableParallelBuilding = true;
  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libpng libjpeg ] ++ lib.optional guiSupport libX11;

  meta = with stdenv.lib; {
    description = "A general purpose cross-platform C++ machine learning library";
    homepage = "http://www.dlib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ christopherpoole ma27 ];
    platforms = platforms.linux;
  };
}
