{ stdenv, fetchurl, python, cairomm, sparsehash, pycairo, autoreconfHook,
pkgconfig, boost, expat, scipy, numpy, cgal, gmp, mpfr, lndir,
gobjectIntrospection, pygobject3, gtk3, matplotlib }:

stdenv.mkDerivation rec {
  version = "2.22";
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
    sha256 = "1070lp8nzsg9lw6f0qaw6zn7v7mmvn65nf1sic9rriv34xb1n4jp";
  };

  configureFlags = [
    "--with-python-module-path=$(out)/${python.sitePackages}"
    "--with-expat=${expat}"
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
