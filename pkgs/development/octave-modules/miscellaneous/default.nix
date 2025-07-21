{
  buildOctavePackage,
  lib,
  fetchurl,
  # Build-time dependencies
  ncurses, # >= 5
  units,
}:

buildOctavePackage rec {
  pname = "miscellaneous";
  version = "1.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-VxIReiXTHRJmADZGpA6B59dCdDPCY2bkJt/6mrir1kg=";
  };

  buildInputs = [
    ncurses
  ];

  propagatedBuildInputs = [
    units
  ];

  meta = {
    homepage = "https://gnu-octave.github.io/packages/miscellaneous/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Miscellaneous tools that don't fit somewhere else";
  };
}
