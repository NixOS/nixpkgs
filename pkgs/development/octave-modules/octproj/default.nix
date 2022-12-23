{ buildOctavePackage
, lib
, fetchurl
, proj # >= 6.3.0
}:

buildOctavePackage rec {
  pname = "octproj";
  version = "3.0.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-G2Ajnt4KGaq9hdXHLHL+6d9lGb83wkMHZqswNijwSzs=";
  };

  # The sed changes below allow for the package to be compiled.
  patchPhase = ''
    sed -i s/"error(errorText)"/"error(\"%s\", errorText)"/g src/*.cc
    sed -i s/"warning(errorText)"/"warning(\"%s\", errorText)"/g src/*.cc
  '';

  propagatedBuildInputs = [
    proj
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/octproj/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "GNU Octave bindings to PROJ library for cartographic projections and CRS transformations";
    broken = true; # error: unlink: operation failed: No such file or directory
  };
}
