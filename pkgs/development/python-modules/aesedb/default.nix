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
  version = "0.1.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-pnbzPVXr3qgBH7t5wNR+jbTdQGMdnLpV+xfgQjdc+7A=";
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
    changelog = "https://github.com/skelsec/aesedb/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
