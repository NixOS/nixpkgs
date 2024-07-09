{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  git,
  lxml,
  rnc2rng,
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

  buildInputs = [ rnc2rng ];

  build-system = [ setuptools ];

  dependencies = [ lxml ];

  nativeCheckInputs = [
    pytestCheckHook
    git
  ];
  # doCheck = false;  # seems to want a Git repository, but fetchgit with leaveDotGit also fails
  pythonImportsCheck = [ "citeproc" ];

  meta = {
    homepage = "https://github.com/brechtm/citeproc-py";
    description = "Citation Style Language (CSL) parser for Python";
    mainProgram = "csl_unsorted";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
}
