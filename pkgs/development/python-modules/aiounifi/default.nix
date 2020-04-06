{ lib, buildPythonPackage, fetchPypi, isPy3k
, aiohttp }:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "11";

  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e751cfd002f54dda76dfd498dcc53cb6fab6bff79773ca7d18c9c7b392046b12";
  };

  propagatedBuildInputs = [ aiohttp ];

  # upstream has no tests
  doCheck = false;

  meta = with lib; {
    description = "An asynchronous Python library for communicating with Unifi Controller API";
    homepage    = https://pypi.python.org/pypi/aiounifi/;
    license     = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
  };
}
