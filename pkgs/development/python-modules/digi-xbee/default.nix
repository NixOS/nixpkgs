{ buildPythonPackage, fetchFromGitHub, isPy27, pyserial, srp, lib }:

buildPythonPackage rec {
  pname = "digi-xbee";
  version = "1.4.0";
  disabled = isPy27;

  src = fetchFromGitHub {
     owner = "digidotcom";
     repo = "xbee-python";
     rev = "1.4.0";
     sha256 = "1c2mavpf31vfjd7plrfw87hcxmhkwf7p5bnazsc3dn5xqjdh3j3f";
  };

  propagatedBuildInputs = [ pyserial srp ];

  # Upstream doesn't contain unit tests, only functional tests which require specific hardware
  doCheck = false;

  pythonImportsCheck = [
    "digi.xbee.models"
    "digi.xbee.packets"
    "digi.xbee.util"
    "digi.xbee.comm_interface"
    "digi.xbee.devices"
    "digi.xbee.exception"
    "digi.xbee.filesystem"
    "digi.xbee.firmware"
    "digi.xbee.io"
    "digi.xbee.profile"
    "digi.xbee.reader"
    "digi.xbee.recovery"
    "digi.xbee.sender"
    "digi.xbee.serial"
    "digi.xbee.xsocket"
  ];

  meta = with lib; {
    description = "Python library to interact with Digi International's XBee radio frequency modules";
    homepage = "https://github.com/digidotcom/xbee-python";
    license = licenses.mpl20;
    maintainers = with maintainers; [ jefflabonte ];
  };
}
