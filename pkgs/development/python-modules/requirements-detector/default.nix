{
  lib,
  astroid,
  buildPythonPackage,
  fetchFromGitHub,
  packaging,
  poetry-core,
  semver,
  tomli,
  pytestCheckHook,
  stdenv, # for meta.broken
}:

buildPythonPackage (finalAttrs: {
  pname = "requirements-detector";
  version = "1.6.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "landscapeio";
    repo = "requirements-detector";
    tag = finalAttrs.version;
    hash = "sha256-AdKVZUb3MTxh6mRJly0xcCm6ogu83m0IsKcamSUup7M=";
  };

  build-system = [ poetry-core ];

  pythonRelaxDeps = lib.optionals stdenv.hostPlatform.isDarwin [ "astroid" ];

  dependencies = [
    astroid
    packaging
    semver
    tomli
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "requirements_detector" ];

  meta = {
    description = "Python tool to find and list requirements of a Python project";
    homepage = "https://github.com/landscapeio/requirements-detector";
    changelog = "https://github.com/landscapeio/requirements-detector/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "detect-requirements";
  };
})
