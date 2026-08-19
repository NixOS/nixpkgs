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
  typing-extensions,
  vcrpy,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygitguardian";
  version = "1.33.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "GitGuardian";
    repo = "py-gitguardian";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K0hsOfU0tCvjTjOFaDrYNATO31YgbfgAYkZh1DxQNIw=";
  };

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

  meta = {
    description = "Library to access the GitGuardian API";
    homepage = "https://github.com/GitGuardian/py-gitguardian";
    changelog = "https://github.com/GitGuardian/py-gitguardian/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
