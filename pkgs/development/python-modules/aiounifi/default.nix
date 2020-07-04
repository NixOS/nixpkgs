{ lib, buildPythonPackage, fetchPypi, isPy3k
, aiohttp }:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "22";

  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ad2625c8a62e28781d50644f4a4df5a97a32174b965cd3b329820ae85e2dfcc3";
  };

  propagatedBuildInputs = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "An asynchronous Python library for communicating with Unifi Controller API";
    homepage    = "https://pypi.python.org/pypi/aiounifi/";
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
