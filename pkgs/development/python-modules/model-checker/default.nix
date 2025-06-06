{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pythonOlder,
  z3-solver,
}:

buildPythonPackage rec {
  pname = "model-checker";
  version = "0.4.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "model_checker";
    inherit version;
    hash = "sha256-BUkbCllM2qN5yKTvte2iwnmBXQAzu2N8LTGRfvOTKUQ=";
  };

  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  pythonRemoveDeps = [ "z3-solver" ];

  build-system = [ setuptools ];


  dependencies = [ z3-solver ];

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
