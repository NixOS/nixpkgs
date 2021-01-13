{ stdenv, fetchzip, fetchpatch, cmake, tbb, python3, ispc }:

stdenv.mkDerivation rec {
  pname = "openimagedenoise";
  version = "1.2.4";

  # The release tarballs include pretrained weights, which would otherwise need to be fetched with git-lfs
  src = fetchzip {
    url = "https://github.com/OpenImageDenoise/oidn/releases/download/v${version}/oidn-${version}.src.tar.gz";
    sha256 = "sha256-RfmBDOSnrNe2ca0MRGK8CbnNrk2VF1erZQmnYcsmSEE=";
  };

  nativeBuildInputs = [ cmake python3 ispc ];
  buildInputs = [ tbb ];

  patches = [
    (fetchpatch {
      # https://github.com/OpenImageDenoise/oidn/pull/95
      url = "https://github.com/OpenImageDenoise/oidn/commit/31e21d243d2260c8b9a63d1955d9055b0ede8eb5.patch";
      sha256 = "sha256-KdNz1v2PiZdxMkH8x+K3EkMqFhonP/iv21Zx7wQYkA0=";
    })
  ];

  meta = with stdenv.lib; {
    homepage = "https://openimagedenoise.github.io";
    description = "High-Performance Denoising Library for Ray Tracing";
    license = licenses.asl20;
    maintainers = [ maintainers.leshainc ];
    platforms = platforms.unix;
  };
}
