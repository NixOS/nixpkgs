{
  fetchPypi,
  buildPythonPackage,
  passagemath-tachyon,
  cysignals,
  cython,
  gmpy2,
  jupyter-core,
  lrcalc-python,
  memory-allocator,
  numpy,
  pkgconfig,
  passagemath-ppl,
  passagemath-primesieve-primecount,
  requests,
  ipython,
  pexpect,
  sphinx,
  networkx,
  scipy,
  matplotlib,
  pillow,
  ipykernel,
  jupyter-client,
  ipywidgets,
  fpylll,
  passagemath-brial,
  passagemath-cddlib,
  passagemath-cliquer,
  passagemath-combinat,
  passagemath-eclib,
  passagemath-gap-pkg-transgrp-data,
  passagemath-gap-pkg-ctbllib-data,
  passagemath-gap-pkg-tomlib-data,
  passagemath-gap-pkg-irredsol-data,
  passagemath-glpk,
  passagemath-graphs,
  passagemath-groups,
  passagemath-highs,
  passagemath-homfly,
  passagemath-lcalc,
  passagemath-libbraiding,
  passagemath-libecm,
  passagemath-linbox,
  passagemath-modules,
  passagemath-nauty,
  passagemath-ntl,
  passagemath-palp,
  passagemath-pari,
  passagemath-pari-galdata,
  passagemath-pari-seadata-small,
  passagemath-planarity,
  passagemath-plot,
  passagemath-polyhedra,
  passagemath-repl,
  passagemath-schemes,
  passagemath-singular,
  pkgs,
  setuptools,
  passagemath-setup,
  passagemath-environment,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-standard-no-symbolics";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    cython
    pkgconfig
    passagemath-setup
    passagemath-environment
  ];
  buildInputs = with pkgs; [
    flint
    ecl
  ];
  dependencies = [
    lrcalc-python
    passagemath-brial
    passagemath-cddlib
    passagemath-cliquer
    passagemath-combinat
    passagemath-eclib
    passagemath-gap-pkg-transgrp-data
    passagemath-gap-pkg-ctbllib-data
    passagemath-gap-pkg-tomlib-data
    passagemath-gap-pkg-irredsol-data
    passagemath-glpk
    passagemath-graphs
    passagemath-groups
    passagemath-highs
    passagemath-homfly
    passagemath-lcalc
    passagemath-libbraiding
    passagemath-libecm
    passagemath-linbox
    passagemath-modules
    passagemath-nauty
    passagemath-ntl
    passagemath-palp
    passagemath-pari
    passagemath-pari-galdata
    passagemath-pari-seadata-small
    passagemath-planarity
    passagemath-plot
    passagemath-polyhedra
    passagemath-repl
    passagemath-schemes
    passagemath-singular
    passagemath-tachyon
    cysignals
    cython
    gmpy2
    jupyter-core
    memory-allocator
    numpy
    pkgconfig
    passagemath-ppl
    passagemath-primesieve-primecount
    requests
    ipython
    pexpect
    sphinx
    networkx
    scipy
    matplotlib
    pillow
    ipykernel
    jupyter-client
    ipywidgets
    fpylll
  ];

  pythonRelaxDeps = [ "sphinx" ];
  postInstall = ''
    find "$out" -type d -name __pycache__ -prune -exec rm -rf {} +
  '';

  src = fetchPypi {
    pname = "passagemath_standard_no_symbolics";
    inherit version;
    hash = "sha256-T4GoMepkAF4kqJQWH6uf0ylWAe06QqUyKtAXha4Qb1Y=";
  };
}
