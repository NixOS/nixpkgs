{ buildOctavePackage
, lib
, fetchurl
, blas
}:

buildOctavePackage rec {
  pname = "nan";
  version = "3.5.3";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "1jailahbrh847875vszibn68lp4n5sdy68q51i7hd64qix8rmmpx";
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
