{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "instrument-control";
  version = "0.9.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-5ZufEs761qz0nKt0YYikJccqEtK+Qs9UcnJlRsW8VCM=";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/instrument-control/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Low level I/O functions for serial, i2c, spi, parallel, tcp, gpib, vxi11, udp and usbtmc interfaces";
  };
}
