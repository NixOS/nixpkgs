{
  buildOctavePackage,
  lib,
  fetchFromBitbucket,
}:

buildOctavePackage rec {
  pname = "octclip";
  version = "2.0.3";

  src = fetchFromBitbucket {
    owner = "jgpallero";
    repo = pname;
    rev = "OctCLIP-${version}";
    sha256 = "sha256-gG2b8Ix6bzO6O7GRACE81JCVxfXW/+ZdfoniigAEq3g=";
  };

  # The only compilation problem is that no formatting specifier was provided
  # for the error function. Because errorText is a string, I provide such a
  # formatting specifier.
  patchPhase = ''
    sed -i s/"error(errorText)"/"error(\"%s\", errorText)"/g src/*.cc
  '';

  meta = {
    name = "GNU Octave Clipping Polygons Tool";
    homepage = "https://gnu-octave.github.io/packages/octclip/";
    license = with lib.licenses; [ gpl3Plus ]; # modified BSD?
    maintainers = with lib.maintainers; [ KarlJoad ];
    description = "Perform boolean operations with polygons using the Greiner-Hormann algorithm";
  };
}
