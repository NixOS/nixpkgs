{
  lib,
  buildPythonPackage,
  cffi,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pyspx";
  version = "0.5.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "sphincs";
    repo = "pyspx";
    tag = "v${version}";
    hash = "sha256-hMZ7JZoo5RdUwQYpGjtZznH/O6rBUXv+svfOAI0cjqs=";
    fetchSubmodules = true;
  };

  build-system = [
    cffi
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyspx" ];

  meta = with lib; {
    description = "Python bindings for SPHINCS";
    homepage = "https://github.com/sphincs/pyspx";
    changelog = "https://github.com/sphincs/pyspx/releases/tag/v${version}";
    license = licenses.cc0;
    maintainers = with maintainers; [ fab ];
  };
}
