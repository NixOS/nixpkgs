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
  version = "1.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "c8c27c98c0a1deac2d32d417c4ca536b08be2655a9a6de8a7897e8bc6431858c";
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
