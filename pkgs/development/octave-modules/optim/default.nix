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
  version = "1.6.1";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1175bckiryz0i6zm8zvq7y5rq3lwkmhyiky1gbn33np9qzxcsl3i";
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
