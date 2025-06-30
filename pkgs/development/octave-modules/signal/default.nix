{
  buildOctavePackage,
  lib,
  fetchurl,
  control,
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

  meta = {
    homepage = "https://gnu-octave.github.io/packages/signal/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Signal processing tools, including filtering, windowing and display functions";
  };
}
