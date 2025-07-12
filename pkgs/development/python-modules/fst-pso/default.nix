{
  lib,
  buildPythonPackage,
  fetchPypi,
  miniful,
  numpy,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "fst-pso";
  version = "1.9.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "fst_pso";
    inherit version;
    hash = "sha256-znf1A/Vcz5ELFGFrpDzdj8O3XEDxpu+mCCb35GfWqN8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    miniful
    numpy
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "fstpso" ];

  meta = with lib; {
    description = "Fuzzy Self-Tuning PSO global optimization library";
    homepage = "https://github.com/aresio/fst-pso";
    changelog = "https://github.com/aresio/fst-pso/releases/tag/${version}";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
