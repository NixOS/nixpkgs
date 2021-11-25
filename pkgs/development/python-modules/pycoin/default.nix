{ lib
, fetchPypi
, buildPythonPackage
, gnupg
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pycoin";
  version = "0.91.20210515";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d2231a8d11b2524c26472d08cf1b76569849ab44507495d0510165ae0af4858e";
  };

  propagatedBuildInputs = [ setuptools ];

  postPatch = ''
    substituteInPlace ./pycoin/cmds/tx.py --replace '"gpg"' '"${gnupg}/bin/gpg"'
  '';

  checkInputs = [ pytestCheckHook ];

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
