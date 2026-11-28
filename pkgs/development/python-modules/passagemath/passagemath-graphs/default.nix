{
  boost,
  buildPythonPackage,
  callPackage,
  cysignals,
  cython,
  fetchPypi,
  gmp,
  gmpy2,
  lib,
  libmpc,
  mpfr,
  passagemath-categories,
  passagemath-environment,
  passagemath-setup,
  pkgconfig,
  setuptools,
  ...
}:
let
  memory-allocator = callPackage ../downgrades/memory-allocator { };
in
buildPythonPackage rec {
  pname = "passagemath-graphs";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    cython
    pkgconfig
    passagemath-setup
    passagemath-environment
  ];

  buildInputs = [
    gmp
    mpfr
    libmpc
    boost
  ];

  dependencies = [
    gmpy2
    memory-allocator
    cysignals
    passagemath-environment
    passagemath-categories
  ];

  src = fetchPypi {
    pname = "passagemath_graphs";
    inherit version;
    hash = "sha256-unnjdZnN+Yuml26WBcNLfHmbXXDGROGAyMqmkbxsRKE=";
  };

  meta = {
    description = "passagemath: Graphs, posets, hypergraphs, designs, abstract complexes, combinatorial polyhedra, abelian sandpiles, quivers";
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
