{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, opentelemetry-api
, opentelemetry-sdk
, std-uritemplate
, pytest-asyncio
, pytest-mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "microsoft-kiota-abstractions";
  version = "1.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "kiota-abstractions-python";
    rev = "v${version}";
    hash = "sha256-lIhVBEZsxq6VnldlgpEknfF3/sOnATCYzvY4V6wZCz4=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    opentelemetry-api
    opentelemetry-sdk
    std-uritemplate
  ];

  pythonImportsCheck = [ "kiota_abstractions" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-mock
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/microsoft/kiota-abstractions-python/blob/${src.rev}/CHANGELOG.md";
    description = "Abstractions library for Kiota generated Python clients";
    homepage = "https://github.com/microsoft/kiota-abstractions-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
