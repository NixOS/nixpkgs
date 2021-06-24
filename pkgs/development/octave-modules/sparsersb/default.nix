{ buildOctavePackage
, lib
, fetchurl
, librsb
}:

buildOctavePackage rec {
  pname = "sparsersb";
  version = "1.0.8";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0nl7qppa1cm51188hqhbfswlih9hmy1yz7v0f5i07z0g0kbd62xw";
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
