{ lib
, stdenv
, buildPythonPackage
, click
, colorama
, cryptography
, exrex
, fetchFromGitHub
, poetry-core
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
  version = "1.6.1";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "mBouamama";
    repo = "MyJWT";
    rev = "refs/tags/${version}";
    hash = "sha256-qdDA8DpJ9kAPTvCkQcPBHNlUqxwsS0vAESglvUygXhg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "1.6.0" "${version}" \
      --replace 'cryptography = "^39.0.2"' 'cryptography = "^39.0.0"'
  '';

  nativeBuildInputs = [
    poetry-core
  ];

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

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    requests-mock
  ];

  pythonImportsCheck = [
    "myjwt"
  ];

  meta = with lib; {
    description = "CLI tool for testing vulnerabilities of JSON Web Tokens (JWT)";
    homepage = "https://github.com/mBouamama/MyJWT";
    changelog = "https://github.com/tyki6/MyJWT/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    # Build failures
    broken = stdenv.isDarwin;
  };
}
