{ lib
, aiohttp
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "faadelays";
  version = "0.0.6";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "02z8p0n9d6n4l6v1m969009gxwmy5v14z108r4f3swd6yrk0h2xd";
  };

  propagatedBuildInputs = [ aiohttp ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "faadelays" ];

  meta = with lib; {
    description = "Python package to retrieve FAA airport status";
    homepage = "https://github.com/ntilley905/faadelays";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
