{ buildOctavePackage
, lib
, fetchurl
, mpfr
}:

buildOctavePackage rec {
  pname = "interval";
  version = "3.2.0";

  src = fetchurl {
    url = "mirror://sourceforge/octave/${pname}-${version}.tar.gz";
    sha256 = "0a0sz7b4y53qgk1xr4pannn4w7xiin2pf74x7r54hrr1wf4abp20";
  };

  propagatedBuildInputs = [
    mpfr
  ];

  meta = with lib; {
    homepage = "https://octave.sourceforge.io/interval/index.html";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ KarlJoad ];
    description = "Interval arithmetic to evaluate functions over subsets of their domain";
    longDescription = ''
       The interval package for real-valued interval arithmetic allows one to
       evaluate functions over subsets of their domain. All results are verified,
       because interval computations automatically keep track of any errors.

       These concepts can be used to handle uncertainties, estimate arithmetic
       errors and produce reliable results. Also it can be applied to
       computer-assisted proofs, constraint programming, and verified computing.

       The implementation is based on interval boundaries represented by
       binary64 numbers and is conforming to IEEE Std 1788-2015, IEEE standard
       for interval arithmetic.
    '';
  };
}
