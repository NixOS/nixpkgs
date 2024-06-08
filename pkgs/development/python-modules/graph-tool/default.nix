{
  buildPythonPackage,
  lib,
  fetchurl,
  stdenv,

  autoreconfHook,
  boost185,
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
}:

let
  # graph-tool doesn't build against boost181 on Darwin
  boost = boost185.override {
    enablePython = true;
    inherit python;
  };
in
buildPythonPackage rec {
  pname = "graph-tool";
  version = "2.68";
  format = "other";

  src = fetchurl {
    url = "https://downloads.skewed.de/graph-tool/graph-tool-${version}.tar.bz2";
    hash = "sha256-jB+/R6yZVhU0iohxYVNHdD205MauRxMoohbj4a2T+rw=";
  };

  # Remove error messages about tput during build process without adding ncurses,
  # and replace unavailable git commit hash and date.
  postPatch = ''
    substituteInPlace configure.ac \
      --replace-fail 'tput setaf $1' : \
      --replace-fail 'tput sgr0' : \
      --replace-fail \
        "\"esyscmd(git show | head -n 1 | sed 's/commit //' |  grep -o -e '.\{8\}' | head -n 1 |tr -d '\n')\"" \
        '["(nixpkgs-${version})"]' \
      --replace-fail \
        "\"esyscmd(git log -1 | head -n 3 | grep 'Date:' | sed s/'Date:   '// | tr -d '\n')\"" \
        '["(unavailable)"]'
  '';

  configureFlags = [
    "--with-python-module-path=$(out)/${python.sitePackages}"
    "--with-boost-libdir=${boost}/lib"
    "--with-cgal=${cgal}"
  ];

  enableParallelBuilding = true;

  build-system = [
    autoreconfHook
    pkg-config
  ];

  # https://graph-tool.skewed.de/installation.html#manual-compilation
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
  ] ++ lib.optionals stdenv.cc.isClang [ llvmPackages.openmp ];

  pythonImportsCheck = [ "graph_tool" ];

  meta = {
    description = "Python module for manipulation and statistical analysis of graphs";
    homepage = "https://graph-tool.skewed.de";
    changelog = "https://git.skewed.de/count0/graph-tool/commits/release-${version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = [ ];
  };
}
