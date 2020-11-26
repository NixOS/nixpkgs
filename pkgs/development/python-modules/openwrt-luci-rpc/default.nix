{ buildPythonPackage
, fetchPypi
, lib
, click
, requests
, packaging
}:

with lib;

buildPythonPackage rec {
  pname = "openwrt-luci-rpc";
  version = "1.1.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "841c7fc956ad42825a2f2cd0cb2aa02005c3482b200ff7aaccd390345c9f3e18";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "requests==2.21.0" "requests"
    substituteInPlace setup.py --replace "packaging==19.1" "packaging"
  '';

  propagatedBuildInputs = [ click requests packaging ];

  meta = {
    description = ''
      Python3 module for interacting with the OpenWrt Luci RPC interface.
      Supports 15.X & 17.X & 18.X or newer releases of OpenWrt.
    '';
    homepage = "https://github.com/fbradyirl/openwrt-luci-rpc";
    license = licenses.asl20;
    maintainers = with maintainers; [ matt-snider ];
  };
}
