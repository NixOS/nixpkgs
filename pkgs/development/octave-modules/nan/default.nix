{ buildOctavePackage
, lib
, fetchurl
, blas
}:

buildOctavePackage rec {
  pname = "nan";
  version = "3.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1zxdg0yg5jnwq6ppnikd13zprazia6w6zpgw99f62mc03iqk5c4q";
  };

  buildInputs = [
    blas
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/nan/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "A statistics and machine learning toolbox for data with and w/o missing values";
  };
}
