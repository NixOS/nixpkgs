{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  poetry-core,
}:

buildPythonPackage rec {
  pname = "mnemonic";
  version = "0.21";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "python-mnemonic";
    rev = "v${version}";
    hash = "sha256-D1mS/JQhefYmwrShfWR9SdiGsBUM+jmuCkfWix9tDOU=";
  };

  build-system = [ poetry-core ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mnemonic" ];

  meta = with lib; {
    description = "Reference implementation of BIP-0039";
    homepage = "https://github.com/trezor/python-mnemonic";
    license = licenses.mit;
    maintainers = with maintainers; [
      np
      prusnak
    ];
  };
}
