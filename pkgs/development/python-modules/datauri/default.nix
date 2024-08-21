{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytestCheckHook,
  pythonOlder,
  setuptools,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "datauri";
  version = "2.2.0";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "fcurella";
    repo = "python-datauri";
    rev = "refs/tags/v${version}";
    hash = "sha256-9BCYC8PW44pB348kkH7aB1YqXXN1VNcBHphlN503M6g=";
  };

  build-system = [ setuptools ];

  dependencies = [ typing-extensions ];

  nativeCheckInputs = [
    pydantic
    pytestCheckHook
  ];

  pythonImportsCheck = [ "datauri" ];

  meta = with lib; {
    description = "Module for Data URI manipulation";
    homepage = "https://github.com/fcurella/python-datauri";
    changelog = "https://github.com/fcurella/python-datauri/releases/tag/v${version}";
    license = licenses.unlicense;
    maintainers = with maintainers; [ yuu ];
  };
}
