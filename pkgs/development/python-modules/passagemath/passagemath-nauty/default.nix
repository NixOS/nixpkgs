{
  buildPythonPackage,
  cysignals,
  cython,
  fetchPypi,
  lib,
  passagemath-environment,
  passagemath-graphs,
  passagemath-setup,
  pkgconfig,
  pkgs,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-nauty";
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
    nauty
  ];
  dependencies = [
    cysignals
    passagemath-environment
    passagemath-graphs
  ];

  src = fetchPypi {
    pname = "passagemath_nauty";
    inherit version;
    hash = "sha256-ms6j8BtS+C075RxbmI50OQ3roarQJWRMD6EZXpkOVHA=";
  };
  meta = {
    description = "passagemath: Find automorphism groups of graphs, generate non-isomorphic graphs with nauty";
    homepage = "https://passagemath.org";
    sourceProvenance = "https://github.com/passagemath/passagemath";
    license = lib.licenses.gpl2Plus;
  };
}
