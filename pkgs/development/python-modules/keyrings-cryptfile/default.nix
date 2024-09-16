{
  lib,
  argon2-cffi,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  keyring,
  pycryptodome,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "keyrings-cryptfile";
  version = "1.3.9";
  pyproject = true;

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    pname = "keyrings.cryptfile";
    inherit version;
    hash = "sha256-fCpFPKuZhUJrjCH3rVSlfkn/joGboY4INAvYgBrPAJE=";
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
    # FileNotFoundError: [Errno 2] No such file or directory: '/build/...
    "test_versions"
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
