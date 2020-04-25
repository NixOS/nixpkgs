{ stdenv
, fetchPypi
, buildPythonPackage
, gnupg
, setuptools
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "pycoin";
  version = "0.90.20200322";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8af579e86c118deb64d39e0d844d53a065cdd8227ddd632112e5667370b53a3";
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

  meta = with stdenv.lib; {
    description = "Utilities for Bitcoin and altcoin addresses and transaction manipulation";
    homepage = "https://github.com/richardkiss/pycoin";
    license = licenses.mit;
    maintainers = with maintainers; [ nyanloutre ];
  };
}
