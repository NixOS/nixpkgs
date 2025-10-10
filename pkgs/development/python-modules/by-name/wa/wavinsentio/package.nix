{
  lib,
  buildPythonPackage,
  fetchPypi,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "wavinsentio";
  version = "0.5.4";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FlxeOaqQkJBWQtEUudbwlCzkK6HWmWTIxjgaI80BlxQ=";
  };

  build-system = [ setuptools ];

  dependencies = [ requests ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "wavinsentio" ];

  meta = with lib; {
    description = "Python module to interact with the Wavin Sentio underfloor heating system";
    homepage = "https://github.com/djerik/wavinsentio";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
