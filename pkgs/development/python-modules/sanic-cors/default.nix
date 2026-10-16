{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  packaging,
  pytestCheckHook,
  sanic,
  sanic-testing,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "sanic-cors";
  version = "2.2.0";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ashleysommer";
    repo = "sanic-cors";
    tag = finalAttrs.version;
    hash = "sha256-MZlTyP7O7p5bu7wvmMGeUkXD44IuV+Oq5BRdCScci2M=";
  };

  build-system = [ setuptools ];

  dependencies = [
    packaging
    sanic
  ];

  nativeCheckInputs = [
    pytestCheckHook
    sanic-testing
  ];

  disabledTestPaths = [
    # Fails with current Sanic due to stricter duplicate route-name checks
    "tests/decorator/test_exception_interception.py"
    "tests/extension/test_app_extension.py"
  ];

  pythonImportsCheck = [ "sanic_cors" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Sanic extension for handling Cross Origin Resource Sharing (CORS)";
    homepage = "https://github.com/ashleysommer/sanic-cors";
    changelog = "https://github.com/ashleysommer/sanic-cors/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
