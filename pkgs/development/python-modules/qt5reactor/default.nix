{ lib
, buildPythonPackage
, fetchPypi
, pyqt5
, twisted
, pytest-twisted
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "qt5reactor";
  version = "0.6.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c3470a8a25d9a339f9ca6243502a9b2277f181d772b7acbff551d5bc363b7572";
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

  meta = with lib; {
    description = "Twisted Qt Integration";
    homepage = "https://github.com/twisted/qt5reactor";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
