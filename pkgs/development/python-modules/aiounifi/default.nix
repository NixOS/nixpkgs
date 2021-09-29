{ lib, buildPythonPackage, fetchPypi, isPy3k
, aiohttp }:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "27";

  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-e84EwhyHxO7KHbWFzCiXw285q2baUkE7J25tED3Yt2o=";
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
