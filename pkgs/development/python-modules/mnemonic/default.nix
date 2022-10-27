{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mnemonic";
  version = "0.20";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "sha256-YYgWlYfVd1iALOziaUI8uVYjJDCIVk/dXcUmJd2jcvQ=";
  };

  checkInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mnemonic" ];

  meta = with lib; {
    description = "Reference implementation of BIP-0039";
    homepage = "https://github.com/trezor/python-mnemonic";
    license = licenses.mit;
    maintainers = with maintainers; [ np prusnak ];
  };
}
