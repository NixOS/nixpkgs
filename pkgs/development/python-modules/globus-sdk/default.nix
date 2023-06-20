{ lib
, buildPythonPackage
, cryptography
, fetchFromGitHub
, pyjwt
, pytestCheckHook
, pythonOlder
, requests
, responses
, typing-extensions
}:

buildPythonPackage rec {
  pname = "globus-sdk";
  version = "3.21.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "globus";
    repo = "globus-sdk-python";
    rev = "refs/tags/${version}";
    hash = "sha256-1qWjg4EfN6KDxPX2jVQ/hCI2y3yCVHTpt57cUmObkQw=";
  };

  propagatedBuildInputs = [
    cryptography
    requests
    pyjwt
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    responses
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
    changelog = "https://github.com/globus/globus-sdk-python/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ ixxie ];
  };
}
