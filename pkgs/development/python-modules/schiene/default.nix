{ lib
, beautifulsoup4
, buildPythonPackage
, fetchPypi
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "schiene";
  version = "0.24";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-y1gbeavZNFniRiOBbJ4Mgmb0F01HedSmpAWaeZEv0Go=";
  };

  propagatedBuildInputs = [
    requests
    beautifulsoup4
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "schiene"
  ];

  meta = with lib; {
    description = "Python library for interacting with Bahn.de";
    homepage = "https://github.com/kennell/schiene";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
