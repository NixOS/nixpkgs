{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  python-can,
  canmatrix,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "canopen";
  version = "2.4.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-IKhLxJizTa3XnOzkZ9O74ZWRwcAqjzkzG8xgZcTYsus=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    python-can
    canmatrix
  ];

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
