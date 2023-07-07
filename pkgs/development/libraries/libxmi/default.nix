{ lib, stdenv, fetchurl, libtool }:

stdenv.mkDerivation rec {
  pname = "libxmi";
  version = "1.2";

  src = fetchurl {
    url = "mirror://gnu/libxmi/${pname}-${version}.tar.gz";
    sha256 = "03d4ikh29l38rl1wavb0icw7m5pp7yilnv7bb2k8qij1dinsymlx";
  };

  # For the x86_64 GNU/Linux arch to be recognized by 'configure'
  preConfigure = "cp ${libtool}/share/libtool/build-aux/config.sub .";

  meta = {
    description = "Library for rasterizing 2-D vector graphics";
    homepage = "https://www.gnu.org/software/libxmi/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    maintainers = [ ];
  };
}
