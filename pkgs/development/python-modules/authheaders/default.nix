{ lib
, authres
, buildPythonPackage
, dkimpy
, dnspython
, fetchFromGitHub
, publicsuffix2
, pythonOlder
, pytestCheckHook
, setuptools
}:

buildPythonPackage rec {
  pname = "authheaders";
  version = "0.15.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ValiMail";
    repo = "authentication-headers";
    rev = "refs/tags/${version}";
    hash = "sha256-96fCx5uN7yegTrCN+LSjtu4u3RL+dcxV/Puyo0eziI8=";
  };

  propagatedBuildInputs = [
    authres
    dnspython
    dkimpy
    publicsuffix2
    setuptools
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "authheaders"
  ];

  meta = with lib; {
    description = "Python library for the generation of email authentication headers";
    homepage = "https://github.com/ValiMail/authentication-headers";
    changelog = "https://github.com/ValiMail/authentication-headers/blob${version}/CHANGES";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
