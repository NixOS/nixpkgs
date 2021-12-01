{ buildOctavePackage
, lib
, fetchurl
}:

buildOctavePackage rec {
  pname = "image";
  version = "2.12.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1d3kqhbkq9acc29k42fcilfmykk9a0r321mvk46l5iibc7nqrmg7";
  };

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/image/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Functions for processing images";
    longDescription = ''
       The Octave-forge Image package provides functions for processing
       images. The package also provides functions for feature extraction,
       image statistics, spatial and geometric transformations, morphological
       operations, linear filtering, and much more.
    '';
  };
}
