{
  lib,
  buildPythonPackage,
  fetchPypi,
  networkx,
  setuptools,
  tqdm,
  z3-solver,
}:

buildPythonPackage (finalAttrs: {
  pname = "model-checker";
  version = "1.4.1";
  pyproject = true;

  src = fetchPypi {
    pname = "model_checker";
    inherit (finalAttrs) version;
    hash = "sha256-jEOonA3kmJSW6INkUo4NVzg2Kv4V78QPEJdItYhQ31k=";
  };

  # z3 does not provide a dist-info, so python-runtime-deps-check will fail
  pythonRemoveDeps = [ "z3-solver" ];

  build-system = [ setuptools ];

  dependencies = [
    networkx
    tqdm
    z3-solver
  ];

  # Tests have multiple issues, ImportError, TypeError, etc.
  # Check with the next release > 0.3.13
  doCheck = false;

  pythonImportsCheck = [ "model_checker" ];

  meta = {
    description = "Hyperintensional theorem prover for counterfactual conditionals and modal operators";
    homepage = "https://pypi.org/project/model-checker/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
