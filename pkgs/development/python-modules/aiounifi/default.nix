{ lib, buildPythonPackage, fetchPypi, isPy3k
, aiohttp }:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "27";

  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "7bce04c21c87c4eeca1db585cc2897c36f39ab66da52413b276e6d103dd8b76a";
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
