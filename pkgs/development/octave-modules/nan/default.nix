{ buildOctavePackage
, lib
, fetchurl
, blas
}:

buildOctavePackage rec {
  pname = "nan";
  version = "3.5.2";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0bp8zl50f8qj5sivl88kjdswm035v4li33fiq3v1gmh0pvgbcw7a";
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
