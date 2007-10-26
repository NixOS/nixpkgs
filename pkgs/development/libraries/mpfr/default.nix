args: with args;
stdenv.mkDerivation {
  name = "mpfr-2.3.0";

  src =
	fetchurl {
		url = http://www.mpfr.org/mpfr-current/mpfr-2.3.0.tar.bz2;
		sha256 = "0j1dgpqhw21xc0clm7785jm6k04v9zsssdydvm2z3lcj9ws0v7rm";
	};

  buildInputs =[gmp];

  meta = {
    description = "
	Multi Precision Floating arithmetic with correct Rounding.
";
  };
}
