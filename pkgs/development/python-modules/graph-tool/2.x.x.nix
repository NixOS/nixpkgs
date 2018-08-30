{ stdenv, fetchurl, python, cairomm, sparsehash, pycairo, autoreconfHook,
pkgconfig, boost, expat, scipy, cgal, gmp, mpfr,
gobjectIntrospection, pygobject3, gtk3, matplotlib, ncurses,
buildPythonPackage }:

buildPythonPackage rec {
  pname = "graph-tool";
  format = "other";
  version = "2.26";

  meta = with stdenv.lib; {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage    = https://graph-tool.skewed.de/;
    license     = licenses.gpl3;
    maintainers = [ stdenv.lib.maintainers.joelmo ];
  };

  src = fetchurl {
    url = "https://downloads.skewed.de/graph-tool/graph-tool-${version}.tar.bz2";
    sha256 = "0w7pd2h8ayr88kjl82c8fdshnk6f3xslc77gy7ma09zkbvf76qnz";
  };

  configureFlags = [
    "--with-python-module-path=$(out)/${python.sitePackages}"
    "--with-boost-libdir=${boost}/lib"
    "--with-expat=${expat}"
    "--with-cgal=${cgal}"
    "--enable-openmp"
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig ];
  buildInputs = [ ncurses ];

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
