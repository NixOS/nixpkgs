{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "instrument-control";
  version = "0.9.5";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-Qm1aF+dbhwrDUSh8ViJHCZIc0DiZ1jI117TnSknqzX0=";
  };

  meta = {
    homepage = "https://gnu-octave.github.io/packages/instrument-control/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Low level I/O functions for serial, i2c, spi, parallel, tcp, gpib, vxi11, udp and usbtmc interfaces";
  };
}
