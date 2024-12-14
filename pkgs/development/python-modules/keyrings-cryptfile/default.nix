{
  lib,
  argon2-cffi,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  keyring,
  pycryptodome,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "keyrings-cryptfile";
  version = "1.4.1";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "frispete";
    repo = "keyrings.cryptfile";
    rev = "refs/tags/v${version}";
    hash = "sha256-cDXx0s3o8hNqgzX4oNkjGhNcaUX5vi1uN2d9sdbiZwk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    argon2-cffi
    keyring
    pycryptodome
  ];

  pythonImportsCheck = [ "keyrings.cryptfile" ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  disabledTests = [
    # correct raise `ValueError`s which pytest fails to catch for some reason:
    "test_empty_username"
    # TestEncryptedFileKeyring::test_file raises 'ValueError: Incorrect Password' for some reason, maybe mock related:
    "TestEncryptedFileKeyring"
  ];

  meta = with lib; {
    description = "Encrypted file keyring backend";
    mainProgram = "cryptfile-convert";
    homepage = "https://github.com/frispete/keyrings.cryptfile";
    changelog = "https://github.com/frispete/keyrings.cryptfile/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = [ maintainers.bbjubjub ];
  };
}
