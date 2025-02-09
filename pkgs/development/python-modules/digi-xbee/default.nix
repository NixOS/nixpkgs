{ buildPythonPackage, fetchPypi, isPy27, pyserial, srp, lib }:

buildPythonPackage rec {
  pname = "digi-xbee";
  version = "1.4.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "3b10e749431f406d80c189d872f4673b8d3cd510f7b411f817780a0e72499cd2";
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
