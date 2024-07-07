{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-nextbusnext";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "ViViDboarder";
    repo = "py_nextbus";
    rev = "refs/tags/v${version}";
    hash = "sha256-5zD8AKb4/4x4cVA922OlzSOXlg3F6QCcr16agEQkUWM=";
  };

  nativeBuildInputs = [ setuptools ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "py_nextbus" ];

  meta = with lib; {
    description = "Minimalistic Python client for the NextBus public API";
    homepage = "https://github.com/ViViDboarder/py_nextbus";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
