{ buildOctavePackage
, lib
, fetchFromBitbucket
, proj # >= 6.3.0
}:

buildOctavePackage rec {
  pname = "octproj";
  version = "3.0.2";

  src = fetchFromBitbucket {
    owner = "jgpallero";
    repo = pname;
    rev = "OctPROJ-${version}";
    sha256 = "sha256-d/Zf172Etj+GA0cnGsQaKMjOmirE7Hwyj4UECpg7QFM=";
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
  };
}
