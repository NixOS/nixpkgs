{
  lib,
  buildPythonPackage,
  canmatrix,
  fetchPypi,
  pytestCheckHook,
  python-can,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "canopen";
  version = "2.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
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

  meta = with lib; {
    description = "CANopen stack implementation";
    homepage = "https://github.com/christiansandberg/canopen/";
    changelog = "https://github.com/christiansandberg/canopen/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ sorki ];
  };
}
