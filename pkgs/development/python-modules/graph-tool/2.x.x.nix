{ stdenv, fetchurl, python, cairomm, sparsehash, pycairo, automake, m4, pkgconfig, boost, expat, scipy, numpy, cgal, gmp, mpfr, lndir, makeWrapper }:

stdenv.mkDerivation rec {
  version = "2.2.36";
  name = "${python.libPrefix}-graph-tool-${version}";

  meta = with stdenv.lib; {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage    = http://graph-tool.skewed.de/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
  };

  src = fetchurl {
    url = "http://downloads.skewed.de/graph-tool/graph-tool-${version}.tar.bz2";
    sha256 = "0wp81dp2kd4bzsl6f3gxjmf11hiqr7rz7g0wa1j38fc0chq31q71";
  };

  preConfigure = ''
    configureFlags="--with-python-module-path=$out/${python.sitePackages}"
  '';

  buildInputs = [ python cairomm pycairo sparsehash automake m4 pkgconfig makeWrapper boost expat scipy numpy cgal lndir gmp mpfr ];

  propagatedBuildInputs = [ numpy ];

  enableParallelBuilding = false;
}
