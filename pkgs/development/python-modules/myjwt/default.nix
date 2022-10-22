{ lib
, stdenv
, buildPythonPackage
, click
, colorama
, cryptography
, exrex
, fetchFromGitHub
, pyopenssl
, pyperclip
, pytest-mock
, pytestCheckHook
, pythonOlder
, questionary
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "myjwt";
  version = "1.6.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "mBouamama";
    repo = "MyJWT";
    rev = "refs/tags/${version}";
    sha256 = "sha256-A9tsQ6L+y3doL5pJbau3yKnmQtX2IPXWyW/YCLhS7nc=";
  };

  propagatedBuildInputs = [
    click
    colorama
    cryptography
    exrex
    pyopenssl
    pyperclip
    questionary
    requests
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  postPatch = ''
    # Remove all version pinning (E.g., tornado==5.1.1 -> tornado)
    sed -i -e "s/==[0-9.]*//" requirements.txt
  '';

  pythonImportsCheck = [
    "myjwt"
  ];

  meta = with lib; {
    description = "CLI tool for testing vulnerabilities of JSON Web Tokens (JWT)";
    homepage = "https://github.com/mBouamama/MyJWT";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    # Build failures
    broken = stdenv.isDarwin;
  };
}
