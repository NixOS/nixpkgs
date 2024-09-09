{ lib
, stdenv
, fetchFromGitHub
, cmake
, libminc
, bicpl
, arguments
, pcre-cpp }:

stdenv.mkDerivation rec {
  pname = "oobicpl";
  version = "unstable-2020-08-12";

  src = fetchFromGitHub {
    owner  = "BIC-MNI";
    repo   = pname;
    rev    = "a9409da8a5bb4925438f32aff577b6333faec28b";
    sha256 = "0b4chjhr32wbb1sash8cq1jfnr7rzdq84hif8anlrjqd3l0gw357";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ libminc bicpl arguments pcre-cpp ];

  cmakeFlags = [
    "-DLIBMINC_DIR=${libminc}/lib/cmake"
    "-DBICPL_DIR=${bicpl}/lib"
    "-DARGUMENTS_DIR=${arguments}/lib"
    "-DOOBICPL_BUILD_SHARED_LIBS=TRUE"
  ];

  meta = with lib; {
    homepage = "https://github.com/BIC-MNI/oobicpl";
    description = "Brain Imaging Centre object-oriented programming library (and tools)";
    maintainers = with maintainers; [ bcdarwin ];
    platforms = platforms.unix;
    license   = licenses.free;
  };
}
