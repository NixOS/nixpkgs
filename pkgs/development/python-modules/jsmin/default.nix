{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "jsmin";
  version = "3.0.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wJWaEh75RULoB6Z0FCYG9+kCFKKz0esXMAJEu7XMK/w=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  enabledTestPaths = [ "jsmin/test.py" ];

  pythonImportsCheck = [ "jsmin" ];

  meta = {
    description = "JavaScript minifier";
    homepage = "https://github.com/tikitu/jsmin/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
