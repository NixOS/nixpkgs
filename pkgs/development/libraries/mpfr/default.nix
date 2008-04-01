args: with args;
stdenv.mkDerivation {
  name = "mpfr-2.3.0";

  src = fetchurl {
	  url = http://www.mpfr.org/mpfr-current/mpfr-2.3.1.tar.bz2;
	  sha256 = "0c44va4plxfd9zm7aa24173im38svnb15lbxql5hvxbc9bgzjmyq";
	};

  buildInputs =[gmp];

  meta = {
    description = "
	Multi Precision Floating arithmetic with correct Rounding.
";
  };
}
