{ stdenv, fetchurl, kdelibs, gmpxx }:

stdenv.mkDerivation rec {
  name = "libalkimia-4.3.2";

  src = fetchurl {
    url = "http://kde-apps.org/CONTENT/content-files/137323-${name}.tar.bz2";
    sha256 = "1p7bzi6mz5ymsfsxikk8m1cvi35zirb4fps9axkqlm6mjbwrldv4";
  };

  patchPhase = "sed -e 's/KDE4_DATA_DIR/DATA_INSTALL_DIR/' -i CMakeLists.txt";
  buildInputs = [ kdelibs gmpxx ];

  meta = {
    maintainers = [ stdenv.lib.maintainers.urkud ];
    inherit (kdelibs.meta) platforms;
  };
}
