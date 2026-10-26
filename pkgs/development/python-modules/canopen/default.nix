{
  lib,
  buildPythonPackage,
  canmatrix,
  fetchPypi,
  pytestCheckHook,
  python-can,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "canopen";
  version = "2.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-IKhLxJizTa3XnOzkZ9O74ZWRwcAqjzkzG8xgZcTYsus=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools-scm ];

  dependencies = [ python-can ];

  optional-dependencies = {
    db_export = [ canmatrix ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "canopen" ];

  meta = {
    description = "CANopen stack implementation";
    homepage = "https://github.com/christiansandberg/canopen/";
    changelog = "https://github.com/christiansandberg/canopen/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sorki ];
  };
})
