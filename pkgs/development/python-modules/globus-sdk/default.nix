{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, mypy
, pyjwt
, pytestCheckHook
, pythonOlder
, requests
, responses
, six
, typing-extensions
}:

buildPythonPackage rec {
  pname = "globus-sdk";
  version = "3.10.1";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "globus";
    repo = "globus-sdk-python";
    rev = "refs/tags/${version}";
    hash = "sha256-Un6Fv1Lh4HdYwdU/iR+5JFcPjY2NrFfC9+MkGuaTF8M=";
  };

  propagatedBuildInputs = [
    cryptography
    requests
    pyjwt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  checkInputs = [
    mypy
    pytestCheckHook
    responses
    six
  ];

  postPatch = ''
    substituteInPlace setup.py \
    --replace "pyjwt[crypto]>=2.0.0,<3.0.0" "pyjwt[crypto]>=2.0.0,<3.0.0"
  '';

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  pythonImportsCheck = [
    "globus_sdk"
  ];

  meta = with lib; {
    description = "Interface to Globus REST APIs, including the Transfer API and the Globus Auth API";
    homepage =  "https://github.com/globus/globus-sdk-python";
    license = licenses.asl20;
    maintainers = with maintainers; [ ixxie ];
  };
}
