{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "mnemonic";
  version = "0.20";
  disabled = pythonOlder "3.5";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "1x3jlgfja9n5bpflyml860j26mmr7i16kqpc5j05hxymhyaid231";
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
