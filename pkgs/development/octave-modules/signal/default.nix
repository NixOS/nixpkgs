{ buildOctavePackage
, lib
, fetchurl
, control
}:

buildOctavePackage rec {
  pname = "signal";
  version = "1.4.6";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-lO74/qeMiWCfjd9tX/i/wuDauTK0P4bOkRR0pYtcce4=";
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
