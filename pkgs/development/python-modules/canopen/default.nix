{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools-scm,
  can,
  canmatrix,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "canopen";
  version = "2.2.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XxhlG5325HabmILpafk0rnc+8kpFqrwzNLWGmCBI0Iw=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    can
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
