{stdenv, fetchurl, cmake, zlib, freetype, libjpeg, libtiff, fontconfig,
openssl}:

stdenv.mkDerivation rec {
  name = "podofo-0.7.0";
  src = fetchurl {
    url = "mirror://sourceforge/podofo/${name}.tar.gz";
    sha256 = "1hpd5ldjv013041rmcfrkbk8v6wdpxcg60i3aklik583q2rf0mqy";
  };
  buildInputs = [ cmake zlib freetype libjpeg libtiff fontconfig openssl ];
  cmakeFlags = "-DPODOFO_BUILD_SHARED=ON -DPODOFO_BUILD_STATIC=OFF";
}
