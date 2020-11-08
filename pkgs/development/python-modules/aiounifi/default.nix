{ lib, buildPythonPackage, fetchPypi, isPy3k
, aiohttp }:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "23";

  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0628058b644776132f2f893f1a2201a0142a38b6acf089c6b11a63ad5a752ba7";
  };

  requiredPythonModules = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "An asynchronous Python library for communicating with Unifi Controller API";
    homepage    = "https://pypi.python.org/pypi/aiounifi/";
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
