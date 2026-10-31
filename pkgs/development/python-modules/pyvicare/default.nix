{
  lib,
  authlib,
  buildPythonPackage,
  deprecated,
  fetchFromGitHub,
  hatchling,
  requests,
  pyprojectVersionPatchHook,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvicare";
  version = "2.64.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openviess";
    repo = "PyViCare";
    tag = finalAttrs.version;
    hash = "sha256-Gl/CYWMongvhoGk6xAHMFrl4jy8Nra9yjA+fxIaHtFs=";
  };

  build-system = [ hatchling ];

  nativeBuildInputs = [ pyprojectVersionPatchHook ];

  dependencies = [
    authlib
    deprecated
    requests
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "PyViCare" ];

  meta = {
    description = "Python Library to access Viessmann ViCare API";
    homepage = "https://github.com/somm15/PyViCare";
    changelog = "https://github.com/openviess/PyViCare/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
})
