{ lib, stdenv, buildPythonPackage, fetchFromGitHub, isPyPy, isPy3k
, olefile, freetype, libjpeg, zlib, libtiff, libwebp, tcl, lcms2
, libxcb, tk, libX11, openjpeg, libimagequant, pyroma, numpy
, pytestCheckHook
}@args:

import ../pillow/generic.nix (rec {
  pname = "Pillow-SIMD";
  version = "8.1.2";

  disabled = !isPy3k;

  src = fetchFromGitHub {
    owner = "uploadcare";
    repo = "pillow-simd";
    rev = version;
    sha256 = "1z0c1qpx7l1bhj71ww7za7kl29j5wdraqr2pdhv4dp1q74kgrr0m";
  };

  meta = with lib; {
    homepage = "https://python-pillow.github.io/pillow-perf/";
    description = "The friendly PIL fork - SIMD version";
    longDescription = ''
      Pillow-SIMD is "following" Pillow. Pillow-SIMD versions are 100% compatible drop-in replacements for Pillow of the same version.

      SIMD stands for "single instruction, multiple data" and its essence is in performing the same operation on multiple data points simultaneously by using multiple processing elements. Common CPU SIMD instruction sets are MMX, SSE-SSE4, AVX, AVX2, AVX512, NEON.

      Currently, Pillow-SIMD can be compiled with SSE4 (default) or AVX2 support.
    '';
    license = "http://www.pythonware.com/products/pil/license.htm";
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
} // args )
