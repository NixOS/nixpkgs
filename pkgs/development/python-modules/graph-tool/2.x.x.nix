{ stdenv, fetchurl, python, cairomm, sparsehash, pycairo, automake, m4,
pkgconfig, boost, expat, scipy, numpy, cgal, gmp, mpfr, lndir, makeWrapper,
gobjectIntrospection, pygobject3, gtk3, matplotlib, autoconf, libtool }:

stdenv.mkDerivation rec {
  version = "2.12";
  name = "${python.libPrefix}-graph-tool-${version}";

  meta = with stdenv.lib; {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage    = http://graph-tool.skewed.de/;
    license     = licenses.gpl3;
    platforms   = platforms.all;
    maintainer  = [ stdenv.lib.maintainers.joelmo ];
  };

  src = fetchurl {
    url = "https://github.com/count0/graph-tool/archive/release-${version}.tar.gz";
    sha256 = "12w58djyx6nn00wixqnxnxby9ksabhzdkkvynl8b89parfvfbpwl";
  };

  preConfigure = ''
    patchShebangs autogen.sh
    ./autogen.sh
    configureFlags="--with-python-module-path=$out/${python.sitePackages} --enable-openmp"
  '';

  buildInputs = [ automake m4 pkgconfig makeWrapper autoconf libtool ];

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
