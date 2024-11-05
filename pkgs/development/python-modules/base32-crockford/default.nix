{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "base32-crockford";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jbittel";
    repo = "base32-crockford";
    rev = "refs/tags/${version}";
    hash = "sha256-Msy5xHG0mIm8CEEvUVOmczAndjpyp9ZakHrqc9LxKAs=";
  };

  build-system = [
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pytestFlagsArray = [ "test.py" ];

  pythonImportsCheck = [ "base32_crockford" ];

  meta = {
    description = "Python implementation of Douglas Crockford's base32 encoding scheme";
    homepage = "https://github.com/jbittel/base32-crockford";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
