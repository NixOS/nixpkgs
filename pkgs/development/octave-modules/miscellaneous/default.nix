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
  version = "1.3.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "10n107njz24ln7v9a1l3dkh7s7vd6qwgbinrj1nl4wflxsir4l9k";
  };

  buildInputs = [
    ncurses
  ];

  propagatedBuildInputs = [
    units
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/miscellaneous/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Miscellaneous tools that don't fit somewhere else";
  };
}
