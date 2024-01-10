{ lib
, buildPythonPackage
, fetchPypi
, distro
, pysnmp
, python-gnupg
, qrcode
, requests
, sseclient-py
, zfec
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "blocksat-cli";
  version = "0.4.6";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-uANAMNoAC4HUoUuR5ldxoiy+LLzZVpKosU5JttXLnqg=";
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

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTestPaths = [
    # disable tests which require being connected to the satellite
    "blocksatcli/test_satip.py"
    "blocksatcli/api/test_listen.py"
    "blocksatcli/api/test_msg.py"
    "blocksatcli/api/test_net.py"
    # disable tests which require being online
    "blocksatcli/api/test_order.py"
  ];

  disabledTests = [
    "test_monitor_get_stats"
    "test_monitor_update_with_reporting_enabled"
    "test_erasure_recovery"
  ];

  pythonImportsCheck = [
    "blocksatcli"
  ];

  meta = with lib; {
    description = "Blockstream Satellite CLI";
    homepage = "https://github.com/Blockstream/satellite";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ prusnak ];
  };
}
