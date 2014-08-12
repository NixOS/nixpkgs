{ stdenv, fetchurl, libtool }:

stdenv.mkDerivation {
  name = "libxmi-1.2";

  src = fetchurl {
    url = mirror://gnu/libxmi/libxmi-1.2.tar.gz;
    sha256 = "03d4ikh29l38rl1wavb0icw7m5pp7yilnv7bb2k8qij1dinsymlx";
  };

  # For the x86_64 GNU/Linux arch to be recognized by 'configure'
  preConfigure = "cp ${libtool}/share/libtool/config/config.sub .";

  meta = {
    description = "GNU libxmi, a library for rasterizing 2-D vector graphics";
    homepage = http://www.gnu.org/software/libxmi/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.gnu;  # arbitrary choice
    maintainers = [ stdenv.lib.maintainers.ludo ];
  };
}
