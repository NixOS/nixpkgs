{ lib
, buildPythonPackage
, certifi
, chardet
, fetchFromGitHub
, idna
, pythonOlder
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "frigidaire";
  version = "0.18.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "bm1549";
    repo = pname;
    rev = version;
    sha256 = "sha256-ksh7+F78JBHLMmQddyWMf3XC4Tfp4/AMlegE6qHPe2k=";
  };

  propagatedBuildInputs = [
    certifi
    chardet
    idna
    requests
    urllib3
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "frigidaire"
  ];

  meta = with lib; {
    description = "Python API for the Frigidaire devices";
    homepage = "https://github.com/bm1549/frigidaire";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
