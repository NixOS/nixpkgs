{
  lib,
  stdenv,
  buildPythonPackage,
  click,
  colorama,
  cryptography,
  exrex,
  fetchFromGitHub,
  poetry-core,
  pyopenssl,
  pyperclip,
  pytest-mock,
  pytestCheckHook,
  pythonOlder,
  questionary,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "myjwt";
  version = "2.1.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "mBouamama";
    repo = "MyJWT";
    rev = "refs/tags/${version}";
    hash = "sha256-jqBnxo7Omn5gLMCQ7SNbjo54nyFK7pn94796z2Qc9lg=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "pyopenssl"
    "questionary"
  ];

  build-system = [
    poetry-core
  ];

  dependencies = [
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

  pythonImportsCheck = [ "myjwt" ];

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
