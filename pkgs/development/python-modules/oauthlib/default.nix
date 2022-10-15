{ lib
, blinker
, buildPythonPackage
, cryptography
, fetchFromGitHub
, mock
, pyjwt
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "oauthlib";
  version = "3.2.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "v${version}";
    hash = "sha256-9Du0REnN7AkvMmejXsWc7Uy+YF8MYeLK+QnYHbrPhPA=";
  };

  propagatedBuildInputs = [
    blinker
    cryptography
    pyjwt
  ];

  checkInputs = [
    mock
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "oauthlib"
  ];

  meta = with lib; {
    description = "Generic, spec-compliant, thorough implementation of the OAuth request-signing logic";
    homepage = "https://github.com/idan/oauthlib";
    license = licenses.bsd3;
    maintainers = with maintainers; [ prikhi ];
  };
}
