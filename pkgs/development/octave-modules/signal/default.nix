{ buildOctavePackage
, lib
, fetchurl
, control
}:

buildOctavePackage rec {
  pname = "signal";
  version = "1.4.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "YqTgYRfcxDw2FpkF+CVdAVSBypgq6ukBOw2d8+SOcGI=";
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
