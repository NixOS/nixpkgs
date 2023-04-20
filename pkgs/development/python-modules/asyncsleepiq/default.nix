{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asyncsleepiq";
  version = "1.3.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-zV+R78+6z5q3byv+bAZsqN6NL3OulTqS3EjgQ56IC+Q=";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  pythonNamespaces = [
    "asyncsleepiq"
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [
    "asyncsleepiq"
  ];

  meta = with lib; {
    description = "Async interface to SleepIQ API";
    homepage = "https://github.com/kbickar/asyncsleepiq";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
