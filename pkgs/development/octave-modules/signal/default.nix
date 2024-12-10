{
  buildOctavePackage,
  lib,
  fetchurl,
  control,
}:

buildOctavePackage rec {
  pname = "signal";
  version = "1.4.5";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-VVreL/gPcRiQk5XDNAXwoXpPvNIrxtL7nD9/Rf72SOc=";
  };

  requiredOctavePackages = [
    control
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/signal/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Signal processing tools, including filtering, windowing and display functions";
  };
}
