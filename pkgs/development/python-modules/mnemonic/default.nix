{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mnemonic";
  version = "0.19";

  src = fetchFromGitHub {
    owner = "trezor";
    repo = "python-${pname}";
    rev = "v${version}";
    sha256 = "0rs3szdikkgypiwn43ad3lwh7zvpccw39j5ggkziq6v7pnw3isaq";
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
