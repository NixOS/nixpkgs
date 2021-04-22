{ lib
, aiohttp
, attrs
, python-dateutil
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "connectedcars";
  version = "0.1.5";
  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "niklascp";
    repo = "connectedcars-python";
    rev = "v${version}";
    sha256 = "062fzhg9qd7gzkzanzi2nq27kx7599abcjssxcx8caqzididz0h6";
  };

  propagatedBuildInputs = [
    aiohttp
    attrs
    python-dateutil
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "connectedcars" ];

  meta = with lib; {
    description = "Python package for the ConnectedCars REST API";
    homepage = "https://github.com/niklascp/connectedcars-python";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
