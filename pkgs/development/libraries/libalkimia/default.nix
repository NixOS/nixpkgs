{ stdenv, fetchurl, kdelibs, gmpxx }:

stdenv.mkDerivation rec {
  name = "libalkimia-4.3.1";

  src = fetchurl {
    url = "http://kde-apps.org/CONTENT/content-files/137323-${name}.tar.bz2";
    sha256 = "1l5jgf0wc4s1sk4q5g2v78r9s7dg9k5ikm3pip6cbhjhfc0nv939";
  };

  patchPhase = "sed -e 's/KDE4_DATA_DIR/DATA_INSTALL_DIR/' -i CMakeLists.txt";
  buildInputs = [ kdelibs gmpxx ];

  meta = {
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
