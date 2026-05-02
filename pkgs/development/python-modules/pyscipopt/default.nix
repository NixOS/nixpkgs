{
  lib,
  buildPythonPackage,
  fetchPypi,
  cython,
  numpy,
  scipopt-scip,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyscipopt";
  version = "6.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-emsUT9OnSFqF/6Lm7qcdglHyyou8hMsrNta7CNHBfhc=";
  };

  build-system = [
    cython
    setuptools
  ];

  dependencies = [ numpy ];

  buildInputs = [ scipopt-scip ];

  pythonImportsCheck = [ "pyscipopt" ];

  meta = {
    description = "Python interface and modeling environment for SCIP";
    homepage = "https://github.com/scipopt/PySCIPOpt";
    changelog = "https://github.com/scipopt/PySCIPOpt/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kilianar ];
  };
}
