{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, pretend
, pydantic
, pytestCheckHook
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "id";
  version = "1.3.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "di";
    repo = "id";
    rev = "refs/tags/v${version}";
    hash = "sha256-Yq8tlDh27UEd+NeYuxjPSL8Qh1i19BmF2ZTLJTzXt7E=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    pydantic
    requests
  ];

  nativeCheckInputs = [
    pretend
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "id"
  ];

  meta = with lib; {
    description = "A tool for generating OIDC identities";
    homepage = "https://github.com/di/id";
    changelog = "https://github.com/di/id/blob/${version}/CHANGELOG.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
