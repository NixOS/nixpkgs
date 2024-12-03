{
  lib,
  buildPythonPackage,
  pythonOlder,
  fetchFromGitHub,
  setuptools,
  requests,
  pytestCheckHook,
  responses,
}:

buildPythonPackage rec {
  pname = "herepy";
  version = "3.6.5";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "abdullahselek";
    repo = "HerePy";
    rev = "refs/tags/${version}";
    hash = "sha256-8DwzzC0sTrGnMpuADc55HCIeH/KyWacv8X+Ubh+n7ZM=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [ "herepy" ];

  meta = with lib; {
    changelog = "https://github.com/abdullahselek/HerePy/releases/tag/${version}";
    description = "Library that provides a Python interface to the HERE APIs";
    homepage = "https://github.com/abdullahselek/HerePy";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
