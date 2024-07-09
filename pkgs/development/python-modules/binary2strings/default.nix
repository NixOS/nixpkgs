{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pybind11,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "binary2strings";
  version = "0.1.13";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "glmcdona";
    repo = "binary2strings";
    rev = "refs/tags/v${version}";
    hash = "sha256-3UPT0PdnPAhOu3J2vU5NxE3f4Nb1zwuX3hJiy87nLD0=";
  };

  nativeBuildInputs = [
    pybind11
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "binary2strings" ];

  pytestFlagsArray = [ "tests/test.py" ];

  meta = with lib; {
    description = "Module to extract Ascii, Utf8, and Unicode strings from binary data";
    homepage = "https://github.com/glmcdona/binary2strings";
    changelog = "https://github.com/glmcdona/binary2strings/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
