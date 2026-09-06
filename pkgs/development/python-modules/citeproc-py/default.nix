{
  lib,
  buildPythonPackage,
  fetchPypi,
  git,
  lxml,
  rnc2rng,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "citeproc-py";
  version = "0.9.0";
  pyproject = true;

  src = fetchPypi {
    pname = "citeproc_py";
    inherit version;
    hash = "sha256-WHgdilY+h8p8zrQ9CL6soQ3N+fPPd93zsXiUBx7cJ8g=";
  };

  build-system = [ setuptools ];

  buildInputs = [ rnc2rng ];

  dependencies = [ lxml ];

  nativeCheckInputs = [
    git
    pytestCheckHook
  ];

  pythonImportsCheck = [ "citeproc" ];

  meta = {
    homepage = "https://github.com/citeproc-py/citeproc-py";
    description = "Citation Style Language (CSL) parser for Python";
    mainProgram = "csl_unsorted";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
