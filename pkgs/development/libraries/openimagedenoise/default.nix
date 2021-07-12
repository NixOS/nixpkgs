{ lib, stdenv, fetchzip, cmake, tbb, python3, ispc }:

stdenv.mkDerivation rec {
  pname = "openimagedenoise";
  version = "1.4.0";

  # The release tarballs include pretrained weights, which would otherwise need to be fetched with git-lfs
  src = fetchzip {
    url = "https://github.com/OpenImageDenoise/oidn/releases/download/v${version}/oidn-${version}.src.tar.gz";
    sha256 = "sha256-UsiZT3ufRVo1BQ/md/A3CXpUfMPrJR1DhZg9hrjOG2A=";
  };

  nativeBuildInputs = [ cmake python3 ispc ];
  buildInputs = [ tbb ];

  meta = with lib; {
    homepage = "https://openimagedenoise.github.io";
    description = "High-Performance Denoising Library for Ray Tracing";
    license = licenses.asl20;
    maintainers = [ maintainers.leshainc ];
    platforms = platforms.unix;
    changelog = "https://github.com/OpenImageDenoise/oidn/blob/v${version}/CHANGELOG.md";
  };
}
