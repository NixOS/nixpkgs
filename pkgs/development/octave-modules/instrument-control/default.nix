{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "instrument-control";
  version = "0.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0vckax6rx5v3fq5j6kb6n39a5zas9i24x4wvmjlhc8xbykkg5nkk";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/instrument-control/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Low level I/O functions for serial, i2c, spi, parallel, tcp, gpib, vxi11, udp and usbtmc interfaces";
  };
}
