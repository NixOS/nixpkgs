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
  urllib3,
}:

buildPythonPackage rec {
  pname = "amberelectric";
  version = "2.0.12";
  pyproject = true;

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

  meta = {
    description = "Python Amber Electric API interface";
    homepage = "https://github.com/madpilot/amberelectric.py";
    license = with lib.licenses; [ asl20 ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
