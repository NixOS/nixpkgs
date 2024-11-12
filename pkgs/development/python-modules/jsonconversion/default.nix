{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pdm-backend,
  numpy,
  setuptools,
}:

buildPythonPackage rec {
  pname = "jsonconversion";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "DLR-RM";
    repo = "python-jsonconversion";
    rev = "refs/tags/${version}";
    hash = "sha256-XmAQXu9YkkMUvpf/QVk4u1p8UyNfRb0NeoLxC1evCT4=";
  };

  build-system = [
    pdm-backend
  ];

  pythonRemoveDeps = [
    "pytest-runner"
    "pytest"
  ];

  dependencies = [
    numpy
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "jsonconversion" ];

  meta = with lib; {
    description = "This python module helps converting arbitrary Python objects into JSON strings and back";
    homepage = "https://github.com/DLR-RM/python-jsonconversion";
    license = licenses.bsd2;
    maintainers = [ maintainers.terlar ];
  };
}
