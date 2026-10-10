{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pydantic,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "enochecker-core";
  version = "0.13.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "enowars";
    repo = "enochecker_core";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bmEn+7bx4ZDqHqQKkTnUuBSuVZ6L0w6dZmWK0Po8zWk=";
  };

  build-system = [ setuptools ];

  dependencies = [ pydantic ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "enochecker_core" ];

  meta = {
    description = "Base library for enochecker libs";
    homepage = "https://github.com/enowars/enochecker_core";
    changelog = "https://github.com/enowars/enochecker_core/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fwc ];
  };
})
