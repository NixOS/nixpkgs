{ lib
, buildPythonPackage
, fetchPypi
, netifaces
, paho-mqtt
, pycryptodome
, requests
, six
, zeroconf
}:

buildPythonPackage rec {
  pname = "libpurecool";
  version = "0.6.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kwbinbg0i4fca1bpx6jwa1fiw71vg0xa89jhq4pmnl5cn9c8kqx";
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
