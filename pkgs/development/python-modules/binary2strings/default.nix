{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pybind11,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "binary2strings";
  version = "0.1.13";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "glmcdona";
    repo = "binary2strings";
    tag = "v${version}";
    hash = "sha256-3UPT0PdnPAhOu3J2vU5NxE3f4Nb1zwuX3hJiy87nLD0=";
  };

  nativeBuildInputs = [
    pybind11
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "binary2strings" ];

  enabledTestPaths = [ "tests/test.py" ];

  meta = {
    description = "Module to extract Ascii, Utf8, and Unicode strings from binary data";
    homepage = "https://github.com/glmcdona/binary2strings";
    changelog = "https://github.com/glmcdona/binary2strings/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
