{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "instrument-control";
  version = "0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-AfrQQy1EuMpO6qGYz+sh4EW5eYi6fE6KaRxro0psSN8=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/instrument-control/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Low level I/O functions for serial, i2c, spi, parallel, tcp, gpib, vxi11, udp and usbtmc interfaces";
  };
}
