{ lib
, buildPythonPackage
, fetchPypi

# propagates
, pycryptodome
, requests
, rtp
, urllib3
}:

buildPythonPackage rec {
  pname = "pytapo";
  version = "3.1.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-e5XeXPwf2QSZ/xgaPBPoRBaTvC8oNYI9/b190wSI4oQ=";
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
    description = "Python library for communication with Tapo Cameras ";
    homepage = "https://github.com/JurajNyiri/pytapo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fleaz ];
  };
}
