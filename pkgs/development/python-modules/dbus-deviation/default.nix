{
  lib,
  buildPythonPackage,
  fetchPypi,
  lxml,
  setuptools,
}:

buildPythonPackage rec {
  pname = "dbus-deviation";
  version = "0.6.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-4GuI7+IjiF0nJd9Rz3ybe0Y9HG8E6knUaQh0MY0Ot6M=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "'setuptools_git >= 0.3'," "" \
      --replace-fail "'sphinx'," ""
  '';

  build-system = [ setuptools ];
  dependencies = [ lxml ];

  pythonImportsCheck = [ "dbusdeviation" ];

  meta = with lib; {
    homepage = "https://tecnocode.co.uk/dbus-deviation/";
    description = "Project for parsing D-Bus introspection XML and processing it in various ways";
    license = licenses.lgpl21Plus;
    maintainers = [ ];
  };
}
