{
  lib,
  aenum,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
  pytest-mock,
  pytestCheckHook,
  python-dateutil,
  pythonOlder,
  urllib3,
}:

buildPythonPackage rec {
  pname = "amberelectric";
  version = "2.0.12";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "madpilot";
    repo = "amberelectric.py";
    tag = "v${version}";
    hash = "sha256-HTelfgOucyQINz34hT3kGxhJf68pxKbiO3L54nt5New=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aenum
    urllib3
    pydantic
    python-dateutil
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
  ];

  pythonImportsCheck = [ "amberelectric" ];

  meta = with lib; {
    description = "Python Amber Electric API interface";
    homepage = "https://github.com/madpilot/amberelectric.py";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
