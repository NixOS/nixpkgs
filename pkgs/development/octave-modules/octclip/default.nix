{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "octclip";
  version = "2.0.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "05ijh3izgfaan84n6zp690nap9vnz0zicjd0cgvd1c6askm7vxql";
  };

  # The only compilation problem is that no formatting specifier was provided
  # for the error function. Because errorText is a string, I provide such a
  # formatting specifier.
  patchPhase = ''
    sed -i s/"error(errorText)"/"error(\"%s\", errorText)"/g src/*.cc
  '';

  meta = with lib; {
    name = "GNU Octave Clipping Polygons Tool";
    homepage = "https://octave.sourceforge.io/octclip/index.html";
    license = with licenses; [ gpl3Plus ]; # modified BSD?
    maintainers = with maintainers; [ KarlJoad ];
    description = "Perform boolean operations with polygons using the Greiner-Hormann algorithm";
  };
}
