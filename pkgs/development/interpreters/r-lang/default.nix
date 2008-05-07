{stdenv, fetchurl, readline, perl, g77_42, libX11, libpng, libXt, zlib}:

stdenv.mkDerivation {
  name = "r-lang-2.7.0";
  src = fetchurl {
    url = http://cran.r-project.org/src/base/R-2/R-2.7.0.tar.gz;
    sha256 = "17ql1j5d9rfpxs04j9v9qyxiysc9nh6yr43lgfdamayzjpia5jqm";
  };

  buildInputs = [readline perl g77_42 libpng libX11 libXt zlib];

	meta = {
		description = "R is a language and environment for statistical computing and graphics";
		longDescription = ''R is a language and environment for statistical computing and graphics. It is a GNU project which is similar to the S language. R provides a wide variety of statistical (linear and nonlinear modelling, classical statistical tests, time-series analysis, classification, clustering, ...) and graphical techniques, and is highly extensible.'';
	  license     = "GPL2";
    homepage    = http://www.r-project.org/;
  };
}
