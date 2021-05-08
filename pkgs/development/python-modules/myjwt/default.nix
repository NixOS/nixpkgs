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
, questionary
, requests
, requests-mock
}:

buildPythonPackage rec {
  pname = "myjwt";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "mBouamama";
    repo = "MyJWT";
    rev = version;
    sha256 = "sha256-kZkqFeaQPd56BVaYmCWAbVu1xwbPAIlQC3u5/x3dh7A=";
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

  pythonImportsCheck = [ "myjwt" ];

  meta = with lib; {
    description = "CLI tool for testing vulnerabilities of JSON Web Tokens (JWT)";
    homepage = "https://github.com/mBouamama/MyJWT";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    # Build failures
    broken = stdenv.isDarwin;
  };
}
