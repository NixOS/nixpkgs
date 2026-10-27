{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  marshmallow-dataclass,
  marshmallow,
  pdm-backend,
  pytestCheckHook,
  requests,
  responses,
  setuptools,
  typeguard,
  typing-extensions,
  vcrpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygitguardian";
  version = "1.35.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GitGuardian";
    repo = "py-gitguardian";
    tag = "v${finalAttrs.version}";
    hash = "sha256-AJ4efKUNBImBBiEFTDAW9YxPLzhhuHJBQTFfUiZZbrs=";
  };

  build-system = [ pdm-backend ];

  dependencies = [
    marshmallow
    marshmallow-dataclass
    requests
    setuptools
    typeguard
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    vcrpy
    responses
  ];

  pythonImportsCheck = [ "pygitguardian" ];

  env.GITGUARDIAN_API_KEY = "Test key for tests";

  meta = {
    description = "Library to access the GitGuardian API";
    homepage = "https://github.com/GitGuardian/py-gitguardian";
    changelog = "https://github.com/GitGuardian/py-gitguardian/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
