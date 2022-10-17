{ buildOctavePackage
, lib
, fetchurl
, librsb
}:

buildOctavePackage rec {
  pname = "sparsersb";
  version = "1.0.9";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0jyy2m7wylzyjqj9n6mjizhj0ccq8xnxm2g6pdlrmncxq1401khd";
  };

  propagatedBuildInputs = [
    librsb
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/sparsersb/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Interface to the librsb package implementing the RSB sparse matrix format for fast shared-memory sparse matrix computations";
  };
}
