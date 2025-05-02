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
  version = "3.3.20";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-lJ3+wGzbgvaB20KOGg3ncKb2XlcraFMk8oEK6newX/A=";
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
