{ buildPythonPackage
, fetchPypi
, lib
, distro
, pysnmp
, python-gnupg
, qrcode
, requests
, sseclient-py
, zfec
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "blocksat-cli";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "06ky5kahh8dm1d7ckid3fdwizvkh3g4aycm39r00kwxdlfca7bgf";
  };

  propagatedBuildInputs = [
    distro
    pysnmp
    python-gnupg
    qrcode
    requests
    sseclient-py
    zfec
  ];

  checkInputs = [ pytestCheckHook ];

  pytestFlagsArray = [
    # disable tests which require being connected to the satellite
    "--ignore=blocksatcli/test_satip.py"
    "--ignore=blocksatcli/api/test_net.py"
    # disable tests which require being online
    "--ignore=blocksatcli/api/test_order.py"
  ];

  meta = with lib; {
    description = "Blockstream Satellite CLI";
    homepage = "https://github.com/Blockstream/satellite";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ prusnak ];
  };
}
