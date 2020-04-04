{ stdenv, fetchFromGitHub, cmake, nasm }:

stdenv.mkDerivation rec {
  pname = "libturbojpeg";
  version = "2.0.4";

  src = fetchFromGitHub {
    owner = "libjpeg-turbo";
    repo = "libjpeg-turbo";
    rev = version;
    sha256 = "0p19xhsydl582swlvj6lsiql7x7kqjn03m2ryrzivr0pxqkzaaf9";
  };

  nativeBuildInputs = [ cmake nasm ];

  meta = with stdenv.lib; {
    description = "libjpeg-turbo is a JPEG image codec that uses SIMD instructions (MMX, SSE2, AVX2, NEON, AltiVec) to accelerate baseline JPEG compression and decompression on x86, x86-64, ARM, and PowerPC systems, as well as progressive JPEG compression on x86 and x86-64 systems.";
    inherit (src.meta) homepage;
    license     = [ licenses.ijg licenses.bsd3 licenses.zlib ];
    platforms   = platforms.linux;
    maintainers = with maintainers; [ colemickens ];
  };
}
