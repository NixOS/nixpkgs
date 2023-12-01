{ lib
, buildPythonPackage
, fetchPypi
, lxml
, setuptools-git
, sphinx
}:

buildPythonPackage rec {
  pname = "dbus-deviation";
  version = "0.6.1";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4GuI7+IjiF0nJd9Rz3ybe0Y9HG8E6knUaQh0MY0Ot6M=";
  };

  postPatch = ''
    sed -i "/'sphinx',/d" setup.py
  '';

  nativeBuildInputs = [
    setuptools-git
    sphinx
  ];

  propagatedBuildInputs = [
    lxml
  ];

  pythonImportsCheck = [ "dbusdeviation" ];

  meta = with lib; {
    homepage = "https://tecnocode.co.uk/dbus-deviation/";
    description = "A project for parsing D-Bus introspection XML and processing it in various ways";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ lilyinstarlight ];
  };
}
