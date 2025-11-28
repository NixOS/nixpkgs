{
  buildPythonPackage,
  lib,
  fetchurl,
  fetchpatch,
  stdenv,

  boost189,
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
  boost' = boost189.override {
    patches = [
      # required to build against Clang >= 21 (https://github.com/boostorg/lexical_cast/pull/87)
      # TODO: drop when upgrading to Boost >= 1.90
      (fetchpatch {
        name = "Reduce-dependency-on-Boost.TypeTraits-now-that-C-11-.patch";
        url = "https://github.com/boostorg/lexical_cast/commit/8fc8a19931c8cb452400af907959fdacbbdd8ec1.patch";
        relative = "include";
        hash = "sha256-OO39ejR+I5ufjqinrMJ6HgjTE7Ph+XBu50PqcIKaIQo=";
      })
    ];
    enablePython = true;
    inherit python;
  };
in
buildPythonPackage rec {
  pname = "graph-tool";
  version = "2.98";
  format = "other";

  src = fetchurl {
    url = "https://downloads.skewed.de/graph-tool/graph-tool-${version}.tar.bz2";
    hash = "sha256-7vGUi5N/XwQ3Se7nX+DG1+jwNlUdlF6dVeN4cLBsxSc=";
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
  ]
  ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

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
