{stdenv, fetchurl, readline, perl, gfortran, libX11, libpng, libXt, zlib, 
withBioconductor ? false
}:

stdenv.mkDerivation {
  name = "r-lang";
  version = "2.12.0";
  src = fetchurl {
    url = http://cran.r-project.org/src/base/R-2/R-2.12.0.tar.gz;
    sha256 = "93d72d845b01c6cd00e58f04b5e78fd6c83de96a8620505ad2a016772af02179";
  };

  bioconductor = if withBioconductor then import ../development/libraries/science/biology/bioconductor { inherit fetchurl stdenv readline; } else null;

  postUnpack = ''
    gunzip R-2.12.0/src/library/Recommended/Matrix_0.999375-44.tar.gz
    tar --file=R-2.12.0/src/library/Recommended/Matrix_0.999375-44.tar --delete Matrix/src/dummy.cpp
    gzip R-2.12.0/src/library/Recommended/Matrix_0.999375-44.tar
  '';

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


