{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "jsmin";
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wJWaEh75RULoB6Z0FCYG9+kCFKKz0esXMAJEu7XMK/w=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pytestFlagsArray = [ "jsmin/test.py" ];

  pythonImportsCheck = [ "jsmin" ];

  meta = with lib; {
    description = "JavaScript minifier";
    homepage = "https://github.com/tikitu/jsmin/";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
