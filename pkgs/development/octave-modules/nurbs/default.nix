{
  buildOctavePackage,
  lib,
  fetchurl,
}:

buildOctavePackage rec {
  pname = "nurbs";
  version = "1.4.4";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-QfF1tu9z/FQWNDirRs5OP3IRJOGkkR2lnHELn3ItknY=";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/nurbs/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Collection of routines for the creation, and manipulation of Non-Uniform Rational B-Splines (NURBS), based on the NURBS toolbox by Mark Spink";
  };
}
