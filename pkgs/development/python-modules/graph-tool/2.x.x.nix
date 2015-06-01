{ stdenv, fetchurl, python, cairomm, sparsehash, pycairo, automake, m4,
pkgconfig, boost, expat, scipy, numpy, cgal, gmp, mpfr, lndir, makeWrapper,
gobjectIntrospection, pygobject3, gtk3, matplotlib }:

stdenv.mkDerivation rec {
  version = "2.2.42";
  name = "${python.libPrefix}-graph-tool-${version}";

  meta = with stdenv.lib; {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage    = http://graph-tool.skewed.de/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainer  = [ stdenv.lib.maintainers.joelmo ];
  };

  src = fetchurl {
    url = "http://downloads.skewed.de/graph-tool/graph-tool-${version}.tar.bz2";
    sha256 = "124qmd0mgam7hm87gscp3836ymhhwwnlfm2c5pzpml06da1w0xg9";
  };

  preConfigure = ''
    configureFlags="--with-python-module-path=$out/${python.sitePackages} --enable-openmp"
  '';

  buildInputs = [ automake m4 pkgconfig makeWrapper ];

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
