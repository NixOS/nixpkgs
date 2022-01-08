{ fetchurl, python, cairomm, sparsehash, pycairo, autoreconfHook
, pkg-config, boost, expat, scipy, cgal, gmp, mpfr
, gobject-introspection, pygobject3, gtk3, matplotlib, ncurses
, buildPythonPackage
, lib
}:

buildPythonPackage rec {
  pname = "graph-tool";
  format = "other";
  version = "2.43";

  src = fetchurl {
    url = "https://downloads.skewed.de/graph-tool/graph-tool-${version}.tar.bz2";
    hash = "sha256-XxvuCUIgz7JIaNsPr0f44v/Sb3fdcJmVhC5NnomNqGw=";
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
