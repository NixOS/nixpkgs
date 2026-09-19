{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mat4py";
  version = "0.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nephics";
    repo = "mat4py";
    tag = "v${version}";
    hash = "sha256-iG0ojfoaIZtEyHTuba1kEGazNKXQxOEGHjRc/YxJHr4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [
    "tests.py"
  ];

  meta = {
    description = "Python module for loading and saving data in the Matlab (TM) MAT-file format";
    homepage = "https://github.com/nephics/mat4py";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ lunaticabs ];
  };
}
