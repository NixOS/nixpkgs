{ buildOctavePackage
, lib
, fetchurl
, struct
, statistics
, lapack
, blas
}:

buildOctavePackage rec {
  pname = "optim";
  version = "1.6.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "sha256-VUqOGLtxla6GH1BZwU8aVXhEJlwa3bW/vzq5iFUkeH4=";
  };

  buildInputs = [
    lapack
    blas
  ];

  requiredOctavePackages = [
    struct
    statistics
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/optim/index.html";
    license = with licenses; [ gpl3Plus publicDomain ];
    # Modified BSD code seems removed
    maintainers = with maintainers; [ KarlJoad ];
    description = "Non-linear optimization toolkit";
  };
}
