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
  version = "1.1.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8074c1ed24cdd1fadc5a99bd63d9313a0a44703714473ed781ed11e7fb45c96f";
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
