{ lib, stdenv, fetchzip, cmake, tbb, python3, ispc }:

stdenv.mkDerivation rec {
  pname = "openimagedenoise";
  version = "1.3.0";

  # The release tarballs include pretrained weights, which would otherwise need to be fetched with git-lfs
  src = fetchzip {
    url = "https://github.com/OpenImageDenoise/oidn/releases/download/v${version}/oidn-${version}.src.tar.gz";
    sha256 = "sha256-ls0F2D5pC+wqhQn1Zh8m8Q/KoK7rAkhKatTY9k+letQ=";
  };

  nativeBuildInputs = [ cmake python3 ispc ];
  buildInputs = [ tbb ];

  meta = with lib; {
    homepage = "https://openimagedenoise.github.io";
    description = "High-Performance Denoising Library for Ray Tracing";
    license = licenses.asl20;
    maintainers = [ maintainers.leshainc ];
    platforms = platforms.unix;
  };
}
