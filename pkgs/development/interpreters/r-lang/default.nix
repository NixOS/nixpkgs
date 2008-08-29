{stdenv, fetchurl, readline, perl, gfortran, libX11, libpng, libXt, zlib, 
withBioconductor ? false
}:

stdenv.mkDerivation {
  name = "r-lang";
  version = "2.7.0";
  src = fetchurl {
    url = http://cran.r-project.org/src/base/R-2/R-2.7.0.tar.gz;
    sha256 = "17ql1j5d9rfpxs04j9v9qyxiysc9nh6yr43lgfdamayzjpia5jqm";
  };

  bioconductor = if withBioconductor then import ../development/libraries/science/biology/bioconductor { inherit fetchurl stdenv readline; } else null;
  
  buildInputs = [readline perl gfortran libpng libX11 libXt zlib];
  configureFlags = ["--enable-R-shlib"] ;

  meta = {
    description = "R is a language and environment for statistical computing and graphics";
    longDescription = ''R is a language and environment for statistical computin
g and graphics. It is a GNU project which is similar to the S language. R provid
es a wide variety of statistical (linear and nonlinear modelling, classical stat
istical tests, time-series analysis, classification, clustering, ...) and graphi
cal techniques, and is highly extensible.'';
    license     = "GPL2";
    homepage    = http://www.r-project.org/;
  };
}


