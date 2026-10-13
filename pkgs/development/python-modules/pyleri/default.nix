{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  unittestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyleri";
  version = "1.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cesbit";
    repo = "pyleri";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EmdQdUKFkt3sERU0Q4JOdoiFIvtRIRIl4V4BTId7Ngo=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [ unittestCheckHook ];

  pythonImportsCheck = [ "pyleri" ];

  meta = {
    description = "Module to parse SiriDB";
    homepage = "https://github.com/cesbit/pyleri";
    changelog = "https://github.com/cesbit/pyleri/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
