{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  setuptools,
  tqdm,
  z3-solver,
}:

buildPythonPackage rec {
  pname = "model-checker";
  version = "0.6.6";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "model_checker";
    inherit version;
    hash = "sha256-8DXy/7BHWYDBriE7YO4JNw5Wl/7sNYowAKOF6p14pIw=";
  };

  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  pythonRemoveDeps = [ "z3-solver" ];

  build-system = [ setuptools ];

  dependencies = [
    tqdm
    z3-solver
  ];

  # Tests have multiple issues, ImportError, TypeError, etc.
  # Check with the next release > 0.3.13
  doCheck = false;

  pythonImportsCheck = [ "model_checker" ];

  meta = with lib; {
    description = "Hyperintensional theorem prover for counterfactual conditionals and modal operators";
    homepage = "https://pypi.org/project/model-checker/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
