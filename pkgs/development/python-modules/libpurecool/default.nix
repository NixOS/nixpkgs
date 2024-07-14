{
  lib,
  buildPythonPackage,
  fetchPypi,
  netifaces,
  paho-mqtt,
  pycryptodome,
  requests,
  six,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "libpurecool";
  version = "0.6.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-HU/EkmWF2noJhjIh1cHb4fDoguLS9LuCYo5E8JaNi88=";
  };

  # Remove vendorized zeroconf, https://github.com/etheralm/libpurecool/issues/33
  postPatch = ''
    rm libpurecool/zeroconf.py
    substituteInPlace libpurecool/dyson_pure_cool_link.py \
      --replace "from .zeroconf import ServiceBrowser, Zeroconf" "from zeroconf import ServiceBrowser, Zeroconf"
  '';

  propagatedBuildInputs = [
    netifaces
    paho-mqtt
    pycryptodome
    requests
    six
    zeroconf
  ];

  # Tests are only present in repo, https://github.com/etheralm/libpurecool/issues/36
  doCheck = false;
  pythonImportsCheck = [ "libpurecool" ];

  meta = with lib; {
    description = "Python library for Dyson devices";
    homepage = "http://libpurecool.readthedocs.io";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
