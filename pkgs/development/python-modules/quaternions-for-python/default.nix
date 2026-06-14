{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "quaternions-for-python";
  version = "1.1.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "zachartrand";
    repo = "Quaternions";
    rev = version;
    hash = "sha256-MAblzujhcxs3zEeEulSROqHzSJtqnA8o0LstumCZiiA=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "quaternions" ];

  meta = {
    description = "Class and mathematical functions for quaternion numbers";
    homepage = "https://github.com/zachartrand/Quaternions";
    changelog = "https://github.com/zachartrand/Quaternions/releases";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dylan-gonzalez ];
  };
}
