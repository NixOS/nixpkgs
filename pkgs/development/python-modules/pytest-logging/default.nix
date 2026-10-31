{
  lib,
  fetchPypi,
  buildPythonPackage,
  pytest,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pytest-logging";
  version = "2015.11.4";
  format = "setuptools";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zsXIXs8Yqrey6tVJijG591hoDvWpArkFSrPyvbt3yJY=";
  };

  build-system = [ setuptools ];
  propagatedBuildInputs = [ pytest ];
  pythonImportsCheck = [ "pytest_logging" ];

  meta = {
    description = "Capture and expose logging records to pytest tests";
    homepage = "https://github.com/blueyed/pytest-logging";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ philocalyst ];
  };
}
