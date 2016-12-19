{stdenv, fetchurl, cmake}:

let
  patch = fetchurl {
    url = mirror://debian/pool/main/libr/libresample/libresample_0.1.3-3.diff.gz;
    sha256 = "063w8rqxw87fc89gas47vk0ll7xl8cy7d8g70gm1l62bqkkajklx";
  };
in
stdenv.mkDerivation {
  name = "libresample-0.1.3";
  src = fetchurl {
    url = mirror://debian/pool/main/libr/libresample/libresample_0.1.3.orig.tar.gz;
    sha256 = "05a8mmh1bw5afqx0kfdqzmph4x2npcs4idx0p0v6q95lwf22l8i0";
  };
  patches = [ patch ];
  preConfigure = ''
    cat debian/patches/1001_shlib-cmake.patch | patch -p1
  '';
  buildInputs = [ cmake ];
  
  meta = {
    description = "A real-time library for sampling rate conversion library";
    license = stdenv.lib.licenses.lgpl2Plus;
    homepage = https://ccrma.stanford.edu/~jos/resample/Free_Resampling_Software.html;
    maintainers = [ stdenv.lib.maintainers.sander ];
    platforms = stdenv.lib.platforms.unix;
  };
}
