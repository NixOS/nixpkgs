{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, click
, colorama
, cryptography
, exrex
, pyopenssl
, pyperclip
, questionary
, requests
, pytestCheckHook
, pytest-mock
, requests-mock
}:

buildPythonPackage rec {
  pname = "myjwt";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "mBouamama";
    repo = "MyJWT";
    rev = version;
    sha256 = "1n3lvdrzp6wbbcygjwa7xar2jnhjnrz7a9khmn2phhkkngxm5rc4";
  };

  patches = [ ./pinning.patch ];

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
    pytestCheckHook
    pytest-mock
    requests-mock
  ];

  pythonImportsCheck = [ "myjwt" ];

  meta = with lib; {
    description = "CLI tool for testing vulnerabilities on Json Web Token(JWT)";
    homepage = "https://github.com/mBouamama/MyJWT";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    # Build failures
    broken = stdenv.isDarwin;
  };
}
