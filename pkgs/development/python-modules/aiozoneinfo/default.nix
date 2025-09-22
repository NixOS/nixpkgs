{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  tzdata,
}:

buildPythonPackage rec {
  pname = "aiozoneinfo";
  version = "0.2.3";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bluetooth-devices";
    repo = "aiozoneinfo";
    tag = "v${version}";
    hash = "sha256-7qd6Yk/K4BLocu8eQK0hLaw2r1jhWIHBr9W4KsAvmx8=";
  };

  build-system = [ poetry-core ];

  dependencies = [ tzdata ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiozoneinfo" ];

  meta = with lib; {
    description = "Tools to fetch zoneinfo with asyncio";
    homepage = "https://github.com/bluetooth-devices/aiozoneinfo";
    changelog = "https://github.com/bluetooth-devices/aiozoneinfo/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
