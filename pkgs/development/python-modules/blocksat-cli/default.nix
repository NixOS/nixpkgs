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
<<<<<<< HEAD
  version = "0.4.6";
=======
  version = "0.4.5";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-uANAMNoAC4HUoUuR5ldxoiy+LLzZVpKosU5JttXLnqg=";
=======
    hash = "sha256-BLR1eivvlbSTx/jr7Rl778apPBcoFCaKOsYOqxS6Fo4=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
