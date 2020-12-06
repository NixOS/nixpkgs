{ lib, buildPythonPackage, fetchPypi, isPy3k
, aiohttp }:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "25";

  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1777effcc4ec8683e53603437887c43fa650f09ef4d148904ce06e2aa11044b7";
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
