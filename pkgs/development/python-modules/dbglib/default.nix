{
  lib,
  buildPythonPackage,
  fetchPypi,
  poetry-core,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "dbglib";
  version = "0.3.0";
  format = "pyproject";
  disabled = pythonOlder "3.9";
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e0/VxJSa9DWnq1WPh7QGrNXd+dx/Afw7PpnrzsmkZ0w=";
  };
  propagatedBuildInputs = [ poetry-core ];
  pythonImportsCheck = [ "dbglib" ];
  meta = with lib; {
    homepage = "https://github.com/savioxavier/dbglib/";
    license = licenses.mit;
    maintainers = [ maintainers.jetpackjackson ];
  };
}
