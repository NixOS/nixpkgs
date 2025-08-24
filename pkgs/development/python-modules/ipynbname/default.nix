{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ipykernel,
}:

buildPythonPackage rec {
  pname = "ipynbname";
  version = "2025.8.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3Mg2fGTEqfC6pqzqPlCf1mlr9dgcmrzrOG4q1u/KyTU=";
  };

  build-system = [ setuptools ];

  dependencies = [ ipykernel ];

  pythonImportsCheck = [ "ipynbname" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    description = "Simply returns either notebook filename or the full path to the notebook";
    homepage = "https://github.com/msm1089/ipynbname";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
