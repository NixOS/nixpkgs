{
  buildOctavePackage,
  lib,
  fetchurl,
  vibes,
}:

buildOctavePackage rec {
  pname = "vibes";
  version = "0.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1zn86rcsjkqg67hphz5inxc5xkgr18sby8za68zhppc2z7pd91ng";
  };

  buildInputs = [
    vibes
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/vibes/index.html";
    license = with licenses; [
      gpl3Plus
      mit
    ];
    maintainers = with maintainers; [ KarlJoad ];
    description = "Easily display results (boxes, pavings) from interval methods";
    longDescription = ''
      The VIBes API allows one to easily display results (boxes, pavings) from
      interval methods. VIBes consists in two parts: (1) the VIBes application
      that features viewing, annotating and exporting figures, and (2) the
      VIBes API that enables your program to communicate with the viewer in order
      to draw figures. This package integrates the VIBes API into Octave. The
      VIBes application is required for operation and must be installed
      separately. Data types from third-party interval arithmetic libraries for
      Octave are also supported.
    '';
    # Marked this way until KarlJoad gets around to packaging the vibes program.
    # https://github.com/ENSTABretagneRobotics/VIBES
    broken = true;
  };
}
