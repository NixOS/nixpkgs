{ fetchurl, python, cairomm, sparsehash, pycairo, autoreconfHook
, pkg-config, boost, expat, scipy, cgal, gmp, mpfr
, gobject-introspection, pygobject3, gtk3, matplotlib, ncurses
, buildPythonPackage
, fetchpatch
, pythonAtLeast
, lib
}:

buildPythonPackage rec {
  pname = "graph-tool";
  format = "other";
  version = "2.31";

  src = fetchurl {
    url = "https://downloads.skewed.de/graph-tool/graph-tool-${version}.tar.bz2";
    sha256 = "0z6n9xkb5yz7z6rlwl6z9gq3ac5vdsby90nhvvvskadsx2pagd7v";
  };

  configureFlags = [
    "--with-python-module-path=$(out)/${python.sitePackages}"
    "--with-boost-libdir=${boost}/lib"
    "--with-expat=${expat}"
    "--with-cgal=${cgal}"
    "--enable-openmp"
  ];

  nativeBuildInputs = [ autoreconfHook pkg-config ];
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
    gobject-introspection
    gtk3
    pycairo
    matplotlib
    pygobject3
  ];

  enableParallelBuilding = false;

  meta = with lib; {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage    = "https://graph-tool.skewed.de/";
    license     = licenses.gpl3;
    maintainers = [ maintainers.joelmo ];
  };
}
