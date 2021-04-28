{ lib
, buildPythonPackage
, fetchFromGitHub
, oauthlib
, pythonOlder
, requests
, requests_oauthlib
}:

buildPythonPackage rec {
  pname = "ondilo";
  version = "0.2.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "JeromeHXP";
    repo = pname;
    rev = version;
    sha256 = "0k7c9nacf7pxvfik3hkv9vvvda2sx5jrf6zwq7r077x7fw5l8d2b";
  };

  propagatedBuildInputs = [
    oauthlib
    requests
    requests_oauthlib
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "ondilo" ];

  meta = with lib; {
    description = "Python package to access Ondilo ICO APIs";
    homepage = "https://github.com/JeromeHXP/ondilo";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
