{ lib
, buildPythonPackage
, fetchPypi
, aiohttp
}:

buildPythonPackage rec {
  pname = "asyncsleepiq";
  version = "1.1.0";

  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "93c944ff84fd23832b188320b10681a3b1caf935dd584cdd4e508a9bcc8fec1b";
  };

  propagatedBuildInputs = [
    aiohttp
  ];

  # upstream has no tests
  doCheck = false;

  pythonImportsCheck = [ "asyncsleepiq" ];

  meta = with lib; {
    description = "Async interface to SleepIQ API";
    homepage = "https://github.com/kbickar/asyncsleepiq";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
