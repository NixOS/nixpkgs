{ stdenv, fetchurl, pkgconfig, python3, python3Packages, at_spi2_core }:

stdenv.mkDerivation rec {
  version = "2.18.0";
  name = "pyatspi-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/pyatspi/2.18/${name}.tar.xz";
    sha256 = "0imbyk2v6c11da7pkwz91313pkkldxs8zfg81zb2ql6h0nnh6vzq";
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
