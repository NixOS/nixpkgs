{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, pytestCheckHook
, certifi
, cryptography
, pretend
, pyopenssl
, twisted
}:

buildPythonPackage rec {
  pname = "pem";
  version = "21.2.0";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "hynek";
    repo = pname;
    rev = version;
    hash = "sha256-mftLdgtgb5J4zwsb1F/4v4K7XTy4VSZBMy3zPV2f1uA=";
  };

  nativeCheckInputs = [
    certifi
    cryptography
    pretend
    pyopenssl
    pytestCheckHook
    twisted
    twisted.optional-dependencies.tls
  ];

  pythonImportsCheck = [
    "pem"
  ];

  meta = with lib; {
    homepage = "https://pem.readthedocs.io/";
    description = "Easy PEM file parsing in Python.";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanotech ];
  };
}
