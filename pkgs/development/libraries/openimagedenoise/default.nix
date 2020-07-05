{ stdenv, fetchzip, cmake, tbb, python, ispc }:

stdenv.mkDerivation rec {
  pname = "openimagedenoise";
  version = "1.2.1";

  # The release tarballs include pretrained weights, which would otherwise need to be fetched with git-lfs
  src = fetchzip {
    url = "https://github.com/OpenImageDenoise/oidn/releases/download/v${version}/oidn-${version}.src.tar.gz";
    sha256 = "1f8s69ixv7nsdap9hc2njli2x75zmlrfq8cy79772gz83kph8s25";
  };

  nativeBuildInputs = [ cmake python ispc ];
  buildInputs = [ tbb ];

  meta = with stdenv.lib; {
    homepage = "https://openimagedenoise.github.io";
    description = "High-Performance Denoising Library for Ray Tracing";
    license = licenses.asl20;
    maintainers = [ maintainers.leshainc ];
    platforms = platforms.unix;
  };
}
