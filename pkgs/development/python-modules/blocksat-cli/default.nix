{ buildPythonPackage, fetchPypi, lib, distro, pysnmp, python-gnupg, qrcode
, requests, sseclient-py, zfec, pytestCheckHook }:

buildPythonPackage rec {
  pname = "blocksat-cli";
  version = "0.4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "96ec5e548dcdb71ada75727d76b34006fe5f6818bd89cf982e15616d41889603";
  };

  propagatedBuildInputs =
    [ distro pysnmp python-gnupg qrcode requests sseclient-py zfec ];

  checkInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # disable tests which require being connected to the satellite
    "blocksatcli/test_satip.py"
    "blocksatcli/api/test_listen.py"
    "blocksatcli/api/test_msg.py"
    "blocksatcli/api/test_net.py"
    # disable tests which require being online
    "blocksatcli/api/test_order.py"
  ];

  pythonImportsCheck = [ "blocksatcli" ];

  meta = with lib; {
    description = "Blockstream Satellite CLI";
    homepage = "https://github.com/Blockstream/satellite";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ prusnak ];
  };
}
