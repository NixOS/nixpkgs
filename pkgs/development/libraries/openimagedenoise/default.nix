{ stdenv, fetchFromGitHub, cmake, tbb, python }:

stdenv.mkDerivation rec {
  pname = "openimagedenoise";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "OpenImageDenoise";
    repo = "oidn";
    rev = "v${version}";
    sha256 = "032s7vablqnmrcc4xf2c94kwj0kbcd64bram10g0yc42fg0a3r9m";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ cmake python ];
  buildInputs = [ tbb ];

  meta = with stdenv.lib; {
    homepage = "https://openimagedenoise.github.io";
    description = "High-Performance Denoising Library for Ray Tracing";
    license = licenses.asl20;
    maintainers = [ maintainers.leshainc ];
    platforms = platforms.unix;
  };
}
