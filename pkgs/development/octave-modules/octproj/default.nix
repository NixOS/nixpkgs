{ buildOctavePackage
, lib
, fetchurl
, proj # >= 6.3.0
}:

buildOctavePackage rec {
  pname = "octproj";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1mb8gb0r8kky47ap85h9qqdvs40mjp3ya0nkh45gqhy67ml06paq";
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
