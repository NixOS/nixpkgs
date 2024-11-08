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
  version = "0.6.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2eOiJPk2/i5QM7XZ/9rKt2nO22HZbE4M8vC0iPHSS04=";
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
