{ lib
, buildPythonPackage
, fetchPypi

# propagates
, pycryptodome
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "pytapo";
  version = "2.9.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-LW14uDQBqIVsigOzO0bNTpjY7Fk0IWAeDMPEuWM/nOo=";
  };

  propagatedBuildInputs = [
    pycryptodome
    requests
    urllib3
  ];

  pythonImportsCheck = [
    "pytapo"
  ];

  # Tests require actual hardware
  doCheck = false;

  meta = with lib; {
    description = "Python library for communication with Tapo Cameras ";
    homepage = "https://github.com/JurajNyiri/pytapo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fleaz ];
  };
}
