{ lib
, aiowinreg
, buildPythonPackage
, colorama
, fetchPypi
, pycryptodomex
, pythonOlder
, tqdm
, unicrypto
}:

buildPythonPackage rec {
  pname = "aesedb";
  version = "0.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TetXhDrWG6MECm/nhsZDUwcOJwP5drFO+YLarGC2pak=";
  };

  propagatedBuildInputs = [
    aiowinreg
    colorama
    pycryptodomex
    tqdm
    unicrypto
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "aesedb"
  ];

  meta = with lib; {
    description = "Parser for JET databases";
    homepage = "https://github.com/skelsec/aesedb";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
