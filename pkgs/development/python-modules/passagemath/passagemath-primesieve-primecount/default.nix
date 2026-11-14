{
  buildPythonPackage,
  callPackage,
  fetchPypi,
  setuptools,
  cython,
  cysignals,
  primesieve,
  lib,
}:
let
  primecount = callPackage ../downgrades/primecount { };
in
buildPythonPackage rec {
  pname = "passagemath-primesieve-primecount";
  version = "0.1.1.2";

  pyproject = true;
  build-system = [
    setuptools
    cython
    cysignals
  ];
  nativeBuildInputs = [
    primecount
    primesieve
  ];
  buildInputs = [
    primecount
    primesieve
  ];
  dependencies = [ cysignals ];

  src = fetchPypi {
    pname = "passagemath_primesieve_primecount";
    inherit version;
    hash = "sha256-77Qgj7hNsRgzb2bahWrXj3X8Ddei4oumPtbN+BPOwI0=";
  };

  pythonImportsCheck = [ "primecountpy" ];

  meta = {
    description = "Cython interface for the primecount library";
    longDescription = ''
      `passagemath-primesieve-primecount` provides a Cython interface to the
      C++ primecount library. It is a compatible fork of primecountpy.
    '';
    homepage = "https://github.com/passagemath/passagemath-primesieve-primecount";
    sourceProvenance = [ lib.sourceTypes.fromSource ];
    license = lib.licenses.gpl2Plus;
  };
}
