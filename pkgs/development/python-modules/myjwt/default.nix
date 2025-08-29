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
  questionary,
  requests,
  requests-mock,
}:

buildPythonPackage rec {
  pname = "myjwt";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mBouamama";
    repo = "MyJWT";
    tag = version;
    hash = "sha256-jqBnxo7Omn5gLMCQ7SNbjo54nyFK7pn94796z2Qc9lg=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "pyopenssl"
    "questionary"
  ];

  build-system = [ poetry-core ];

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

  meta = {
    description = "CLI tool for testing vulnerabilities of JSON Web Tokens (JWT)";
    homepage = "https://github.com/mBouamama/MyJWT";
    changelog = "https://github.com/tyki6/MyJWT/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "myjwt";
    # Build failures
    broken = stdenv.hostPlatform.isDarwin;
  };
}
