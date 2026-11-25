{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "quantities";
  version = "0.17.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "python-quantities";
    repo = "python-quantities";
    tag = "v${version}";
    hash = "sha256-BymcrPQROrgRXxxX1po+t/eIJ7WujK+MijcMYKhNo08=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [ numpy ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "quantities" ];

  meta = {
    description = "Quantities is designed to handle arithmetic and conversions of physical quantities";
    homepage = "https://python-quantities.readthedocs.io/";
    changelog = "https://github.com/python-quantities/python-quantities/blob/v${version}/CHANGES.txt";
    license = lib.licenses.bsd2;
    maintainers = [ ];
  };
}
