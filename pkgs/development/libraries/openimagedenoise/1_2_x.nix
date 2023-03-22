{ lib, stdenv, fetchzip, cmake, tbb, python3, ispc }:

stdenv.mkDerivation rec {
  pname = "openimagedenoise";
  version = "1.2.2";

  # The release tarballs include pretrained weights, which would otherwise need to be fetched with git-lfs
  src = fetchzip {
    url = "https://github.com/OpenImageDenoise/oidn/releases/download/v${version}/oidn-${version}.src.tar.gz";
    sha256 = "0wyaarjxkzlvljmpnr7qm06ma2wl1aik3z664gwpzhizswygk6yp";
  };

  nativeBuildInputs = [ cmake python3 ispc ];
  buildInputs = [ tbb ];

  cmakeFlags = [
    "-DTBB_ROOT=${tbb}"
    "-DTBB_INCLUDE_DIR=${tbb.dev}/include"
  ];

  meta = with lib; {
    homepage = "https://openimagedenoise.github.io";
    description = "High-Performance Denoising Library for Ray Tracing";
    license = licenses.asl20;
    maintainers = [ maintainers.leshainc ];
    platforms = platforms.unix;
  };
}
