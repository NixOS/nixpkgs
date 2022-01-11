{ lib
, buildPythonPackage
, fetchPypi
, ifaddr
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pywilight";
  version = "0.0.73";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-8AYzAePLqCiz/EN6cJShGnrISijBpFHAU/u355f5IjY=";
  };

  propagatedBuildInputs = [
    ifaddr
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "pywilight"
  ];

  meta = with lib; {
    description = "Python API for WiLight device";
    homepage = "https://github.com/leofig-rj/pywilight";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
