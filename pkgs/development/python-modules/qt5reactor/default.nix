{
  lib,
  buildPythonPackage,
  pythonAtLeast,
  fetchPypi,
  pyqt5,
  twisted,
  pytest-twisted,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "qt5reactor";
  version = "0.6.3";
  format = "setuptools";

  # AttributeError: module 'configparser' has no attribute 'SafeConfigParser'
  disabled = pythonAtLeast "3.12";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-w0cKiiXZozn5ymJDUCqbInfxgddyt6y/9VHVvDY7dXI=";
  };

  propagatedBuildInputs = [
    pyqt5
    twisted
  ];

  nativeCheckInputs = [
    pytest-twisted
    pytestCheckHook
  ];

  pythonImportsCheck = [ "qt5reactor" ];

  meta = {
    description = "Twisted Qt Integration";
    homepage = "https://github.com/twisted/qt5reactor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
