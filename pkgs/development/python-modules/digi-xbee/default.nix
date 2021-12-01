{ buildPythonPackage, fetchPypi, isPy27, pyserial, srp, lib }:

buildPythonPackage rec {
  pname = "digi-xbee";
  version = "1.4.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "664737d1aab453ea40b9745f1ee1e88920acff1cce2e07c42e7f5aa64a16e6aa";
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
