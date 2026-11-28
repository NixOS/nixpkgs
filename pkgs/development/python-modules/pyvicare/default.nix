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
  version = "2.67.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "openviess";
    repo = "PyViCare";
    tag = finalAttrs.version;
    hash = "sha256-8rzjrr7fWwyD22HRtBM6Esaun4Cu74XEmXaYwY066gk=";
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
