{
  buildPythonPackage,
  lib,
  fetchurl,

  autoreconfHook,
  boost,
  cairomm,
  cgal,
  expat,
  gmp,
  gobject-introspection,
  gtk3,
  matplotlib,
  mpfr,
  numpy,
  pkg-config,
  pycairo,
  pygobject3,
  python,
  scipy,
  sparsehash,
}:

buildPythonPackage rec {
  pname = "graph-tool";
  version = "2.65";
  format = "other";

  src = fetchurl {
    url = "https://downloads.skewed.de/graph-tool/graph-tool-${version}.tar.bz2";
    hash = "sha256-ozpFv9rri2toG8BeNTqzoJdkwB06GdJ69XjtPkjUKZw=";
  };

  configureFlags = [
    "--with-python-module-path=$(out)/${python.sitePackages}"
    "--with-boost-libdir=${boost}/lib"
    "--with-expat=${expat}"
    "--with-cgal=${cgal}"
    "--enable-openmp"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  # https://git.skewed.de/count0/graph-tool/-/wikis/installation-instructions#manual-compilation
  dependencies = [
    boost
    cairomm
    cgal
    expat
    gmp
    gobject-introspection
    gtk3
    matplotlib
    mpfr
    numpy
    pycairo
    pygobject3
    scipy
    sparsehash
  ];

  meta = with lib; {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage = "https://graph-tool.skewed.de";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
  };
}
