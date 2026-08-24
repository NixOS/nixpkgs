{
  lib,
  fetchPypi,
  buildPythonPackage,
  gnupg,
  setuptools,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pycoin";
  version = "0.92718.20260405";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XqVaoX8L4tS3i1WaiGeP9vSwB8JW4IpAEtjECQz3Evc=";
  };

  propagatedBuildInputs = [ setuptools ];

  postPatch = ''
    substituteInPlace ./pycoin/cmds/tx.py --replace '"gpg"' '"${gnupg}/bin/gpg"'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  # Disable tests depending on online services
  disabledTests = [
    "ServicesTest"
    "test_tx_pay_to_opcode_list_txt"
    "test_tx_fetch_unspent"
    "test_tx_with_gpg"
  ];

  meta = {
    description = "Utilities for Bitcoin and altcoin addresses and transaction manipulation";
    homepage = "https://github.com/richardkiss/pycoin";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ nyanloutre ];
  };
}
