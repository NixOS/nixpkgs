{
  buildPythonPackage,
  cliquer,
  cysignals,
  cython,
  fetchPypi,
  lib,
  passagemath-categories,
  passagemath-setup,
  pkgconfig,
  setuptools,
  ...
}:
buildPythonPackage rec {
  pname = "passagemath-cliquer";
  version = "10.8.13";

  pyproject = true;
  build-system = [
    setuptools
    pkgconfig
    passagemath-setup
    cython
  ];
  buildInputs = [
    cliquer
  ];

  dependencies = [
    cysignals
    passagemath-categories
  ];

  src = fetchPypi {
    pname = "passagemath_cliquer";
    inherit version;
    hash = "sha256-VO/KTJVxsqA4XQqABKeYW4hV99lbYxSxfS55KgeZccw=";
  };

  meta = {
    description = "passagemath: Finding cliques in graphs with cliquer";
    longDescription = ''
      `passagemath-cliquer`` provides an interface to [cliquer](https://users.aalto.fi/~pat/cliquer.html), an exact branch-and-bound algorithm for finding cliques in an arbitrary weighted graph by Patric Östergård.
    '';
    homepage = "https://passagemath.org";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
