{ stdenv, fetchurl, pkgconfig, python3, python3Packages, at_spi2_core }:

stdenv.mkDerivation rec {
  version = "2.16.0";
  name = "pyatspi-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/pyatspi/2.16/${name}.tar.xz";
    sha256 = "185lwgv9bk1fc6vw2xypznzr7p8fhp84ggnrb706zwgalmy8aym6";
  };

  buildInputs = [
    pkgconfig python3 python3Packages.pygobject3 at_spi2_core
  ];

  meta = with stdenv.lib; {
    description = "Python 3 bindings for at-spi";
    homepage = http://www.linuxfoundation.org/en/AT-SPI_on_D-Bus;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jgeerds ];
  };
}
