{ lib, buildPythonPackage, fetchPypi, isPy3k
, aiohttp }:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "4";

  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0594nb8mpfhnnk9jadbdnbn9v7p4sh3430kcgfyhsh7ayw2mpb9m";
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
