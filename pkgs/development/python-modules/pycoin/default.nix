{ lib
, fetchPypi
, buildPythonPackage
, gnupg
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pycoin";
  version = "0.92.20220529";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-PQOWR1teLZ2npQV+q3K+DgiFBejkRoB4gQYjaHLFQqI=";
  };

  propagatedBuildInputs = [ setuptools ];

  postPatch = ''
    substituteInPlace ./pycoin/cmds/tx.py --replace '"gpg"' '"${gnupg}/bin/gpg"'
  '';

  nativeCheckInputs = [ pytestCheckHook ];

  dontUseSetuptoolsCheck = true;

  # Disable tests depending on online services
  disabledTests = [
    "ServicesTest"
    "test_tx_pay_to_opcode_list_txt"
    "test_tx_fetch_unspent"
    "test_tx_with_gpg"
  ];

  meta = with lib; {
    description = "Utilities for Bitcoin and altcoin addresses and transaction manipulation";
    homepage = "https://github.com/richardkiss/pycoin";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
