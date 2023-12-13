{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, fftw
, libpng
, libjpeg
, libwebp
, openblas
, guiSupport ? false
, libX11

  # see http://dlib.net/compile.html
, sse4Support ? stdenv.hostPlatform.sse4_1Support
, avxSupport ? stdenv.hostPlatform.avxSupport
, cudaSupport ? true
}:

stdenv.mkDerivation rec {
  pname = "dlib";
  version = "19.24.2";

  src = fetchFromGitHub {
    owner = "davisking";
    repo = "dlib";
    rev ="v${version}";
    sha256 = "sha256-Z1fScuaIHjj2L1uqLIvsZ7ARKNjM+iaA8SAtWUTPFZk=";
  };

  postPatch = ''
    rm -rf dlib/external
  '';

  cmakeFlags = [
    (lib.cmakeBool "USE_DLIB_USE_CUDA" cudaSupport)
    (lib.cmakeBool "USE_SSE4_INSTRUCTIONS" sse4Support)
    (lib.cmakeBool "USE_AVX_INSTRUCTIONS" avxSupport)
  ];

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    fftw
    libpng
    libjpeg
    libwebp
    openblas
  ] ++ lib.optional guiSupport libX11;

  meta = with lib; {
    description = "A general purpose cross-platform C++ machine learning library";
    homepage = "http://www.dlib.net";
    license = licenses.boost;
    maintainers = with maintainers; [ christopherpoole ];
    platforms = platforms.unix;
  };
}
