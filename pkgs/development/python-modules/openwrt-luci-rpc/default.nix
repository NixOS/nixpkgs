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
  version = "1.1.2";

  srcs = fetchPypi {
    inherit pname version;
    sha256 = "144bw7w1xvpdkad5phflpkl15ih5pvi19799wmvfv8mj1dn1yjhp";
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
