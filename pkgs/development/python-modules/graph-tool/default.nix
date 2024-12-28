{
  buildPythonPackage,
  lib,
  fetchurl,
  stdenv,

  boost,
  cairomm,
  cgal,
  expat,
  gmp,
  gobject-introspection,
  gtk3,
  llvmPackages,
  matplotlib,
  mpfr,
  numpy,
  pkg-config,
  pycairo,
  pygobject3,
  python,
  scipy,
  sparsehash,
  gitUpdater,
}:

let
  boost' = boost.override {
    enablePython = true;
    inherit python;
  };
in
buildPythonPackage rec {
  pname = "graph-tool";
  version = "2.80";
  format = "other";

  src = fetchurl {
    url = "https://downloads.skewed.de/graph-tool/graph-tool-${version}.tar.bz2";
    hash = "sha256-wacOB12+co+tJdw/WpqVl4gKbW/2hDW5HSHwtE742+Y=";
  };

  postPatch = ''
    # remove error messages about tput during build process without adding ncurses
    substituteInPlace configure \
      --replace-fail 'tput setaf $1' : \
      --replace-fail 'tput sgr0' :
  '';

  configureFlags = [
    "--with-python-module-path=$(out)/${python.sitePackages}"
    "--with-boost-libdir=${boost'}/lib"
    "--with-cgal=${cgal}"
  ];

  enableParallelBuilding = true;

  build-system = [ pkg-config ];

  # https://graph-tool.skewed.de/installation.html#manual-compilation
  dependencies = [
    boost'
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
  ] ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  pythonImportsCheck = [ "graph_tool" ];

  passthru.updateScript = gitUpdater {
    url = "https://git.skewed.de/count0/graph-tool";
    rev-prefix = "release-";
  };

  meta = {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage = "https://graph-tool.skewed.de";
    changelog = "https://git.skewed.de/count0/graph-tool/commits/release-${version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ lib.maintainers.mjoerg ];
  };
}
