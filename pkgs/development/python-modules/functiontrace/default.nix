{ lib
, buildPythonPackage
, fetchPypi
, functiontrace-server
, setuptools
, toml
}:

buildPythonPackage rec {
  pname = "functiontrace";
  version = "0.3.7";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-3bnxZFq1/D9ntwfv7O2YU6MnKEDWWIG4zX0e3cgCleg=";
  };

  nativeBuildInputs = [
    setuptools
    toml
  ];

  # `functiontrace` needs `functiontrace-server` in its PATH, both when run as
  # a standalone application and when imported as a python module.
  propagatedBuildInputs = [ functiontrace-server ];

  pythonImportsCheck = [ "functiontrace" ];

  meta = with lib; {
    homepage = "https://functiontrace.com";
    description = "The Python module for Functiontrace";
    license = licenses.prosperity30;
    maintainers = with maintainers; [ mathiassven tehmatt ];
  };
}
