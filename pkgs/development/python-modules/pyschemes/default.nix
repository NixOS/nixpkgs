{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage {
  pname = "pyschemes";
  version = "0-unstable-2022-09-12";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spy16";
    repo = "pyschemes";
    rev = "c8afdbc045c1ff2bd7cc5a963e7084fc096f5257";
    hash = "sha256-jv6dlZlLuJlTqw2V21BUEhCIc/UGvyjbhggw82eGMz0=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyschemes" ];

  meta = {
    description = "Library for validating data structures in Python";
    homepage = "https://github.com/spy16/pyschemes";
    license = lib.licenses.wtfpl;
    maintainers = with lib.maintainers; [ gador ];
  };
}
