{ stdenv, fetchurl, python, cairomm, sparsehash, pycairo, autoreconfHook,
pkgconfig, boost, expat, scipy, numpy, cgal, gmp, mpfr, lndir,
gobjectIntrospection, pygobject3, gtk3, matplotlib }:

stdenv.mkDerivation rec {
  version = "2.16";
  name = "${python.libPrefix}-graph-tool-${version}";

  meta = with stdenv.lib; {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage    = http://graph-tool.skewed.de/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainer  = [ stdenv.lib.maintainers.joelmo ];
  };

  src = fetchurl {
    url = "https://downloads.skewed.de/graph-tool/graph-tool-${version}.tar.bz2";
    sha256 = "3784d4a15b6b5d0e6dab5e3941d24c1e3fee509f7abf9008f64fef2760bd610d";
  };

  configureFlags = [
    "--with-python-module-path=$(out)/${python.sitePackages}"
    "--enable-openmp"
  ];

  buildInputs = [ pkgconfig autoreconfHook ];

  propagatedBuildInputs = [
    boost
    cgal
    expat
    gmp
    mpfr
    python
    scipy
    # optional
    sparsehash
    # drawing
    cairomm
    gobjectIntrospection
    gtk3
    pycairo
    matplotlib
    pygobject3
  ];

  enableParallelBuilding = false;
}
