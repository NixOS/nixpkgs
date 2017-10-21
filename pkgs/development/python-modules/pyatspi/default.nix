{ stdenv, fetchurl, pkgconfig, at_spi2_core, pythonPackages }:

stdenv.mkDerivation rec {
  pname = "pyatspi";
  version = "2.18.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/pyatspi/2.18/${name}.tar.xz";
    sha256 = "0imbyk2v6c11da7pkwz91313pkkldxs8zfg81zb2ql6h0nnh6vzq";
  };

  broken = true;

  buildInputs = [
    at_spi2_core
    pkgconfig
    pythonPackages.python
    pythonPackages.pygobject3
  ];

  meta = with stdenv.lib; {
    description = "Python 3 bindings for at-spi";
    homepage = http://www.linuxfoundation.org/en/AT-SPI_on_D-Bus;
    license = licenses.gpl2;
    maintainers = with maintainers; [ jgeerds ];
    platforms = with platforms; unix;
  };
}
