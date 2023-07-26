{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "nurbs";
  version = "1.4.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "16r05av75nvmkz1knf0nv0gj4fcjjf3jnyf94bdgxf84wahncim7";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/nurbs/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Collection of routines for the creation, and manipulation of Non-Uniform Rational B-Splines (NURBS), based on the NURBS toolbox by Mark Spink";
  };
}
