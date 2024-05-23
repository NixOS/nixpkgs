{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  ipykernel,
}:

buildPythonPackage rec {
  pname = "ipynbname";
  version = "2024.1.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HTxpze6Kl4FPRWpyBOnMGVtLu0ueRcvnV3lrFiST9gY=";
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
