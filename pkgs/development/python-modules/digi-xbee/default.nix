{
  buildPythonPackage,
  fetchPypi,
  pyserial,
  srp,
  lib,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "digi-xbee";
  version = "1.5.0";

  __structuredAttrs = true;
  pyproject = true;

  src = fetchPypi {
    pname = "digi_xbee";
    inherit (finalAttrs) version;
    hash = "sha256-amUrhHIpeRHuShD0cxb2sbbRTpJQZ9/b8otsa1Bo+bI=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyserial
    srp
  ];

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

  meta = {
    description = "Python library to interact with Digi International's XBee radio frequency modules";
    changelog = "https://github.com/digidotcom/xbee-python/blob/${finalAttrs.version}/CHANGELOG.rst";
    homepage = "https://github.com/digidotcom/xbee-python";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jefflabonte ];
  };
})
