{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# propagates
, pycryptodome
, requests
, rtp
, urllib3
}:

buildPythonPackage rec {
  pname = "pytapo";
  version = "3.1.18";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pYzp/iQHTXS+ovtWIwOoUfYg/h/46ZLNZyevK2vQHEA=";
  };

  propagatedBuildInputs = [
    pycryptodome
    requests
    rtp
    urllib3
  ];

  pythonImportsCheck = [
    "pytapo"
  ];

  # Tests require actual hardware
  doCheck = false;

  meta = with lib; {
    description = "Python library for communication with Tapo Cameras";
    homepage = "https://github.com/JurajNyiri/pytapo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fleaz ];
  };
}
