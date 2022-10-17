{ buildOctavePackage
, lib
, fetchurl
, gfortran
}:

buildOctavePackage rec {
  pname = "optiminterp";
  version = "0.3.6";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "05nzj2jmrczbnsr64w2a7kww19s6yialdqnsbg797v11ii7aiylc";
  };

  nativeBuildInputs = [
    gfortran
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/optiminterp/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "An optimal interpolation toolbox for octave";
    longDescription = ''
       An optimal interpolation toolbox for octave. This package provides
       functions to perform a n-dimensional optimal interpolations of
       arbitrarily distributed data points.
    '';
  };
}
