{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow-dataclass,
  marshmallow,
  pdm-backend,
  pytestCheckHook,
  pythonOlder,
  requests,
  responses,
  setuptools,
  typing-extensions,
  vcrpy,
}:

buildPythonPackage rec {
  pname = "pygitguardian";
  version = "1.22.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "GitGuardian";
    repo = "py-gitguardian";
    tag = "v${version}";
    hash = "sha256-AXgsB1ap233o6TP6htOFuQ++AubCRUqGbs5NWT0Qv+w=";
  };

  pythonRelaxDeps = [
    "marshmallow-dataclass"
    "setuptools"
  ];

  build-system = [ pdm-backend ];

  dependencies = [
    marshmallow
    marshmallow-dataclass
    requests
    setuptools
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
    responses
  ];

  pythonImportsCheck = [ "pygitguardian" ];

  env.GITGUARDIAN_API_KEY = "Test key for tests";

  meta = with lib; {
    description = "Library to access the GitGuardian API";
    homepage = "https://github.com/GitGuardian/py-gitguardian";
    changelog = "https://github.com/GitGuardian/py-gitguardian/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
