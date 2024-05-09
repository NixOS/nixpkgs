{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "openwrt-ubus-rpc";
  version = "0.0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "python-ubus-rpc";
    rev = version;
    sha256 = "19scncc1w9ar3pw4yrw24akjgm74n2m7y308hzl1i360daf5p21k";
  };

  propagatedBuildInputs = [
    requests
    urllib3
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "openwrt.ubus" ];

  meta = with lib; {
    description = "Python API for OpenWrt ubus RPC";
    homepage = "https://github.com/Noltari/python-ubus-rpc";
    license = with licenses; [ gpl2Only ];
    maintainers = with maintainers; [ fab ];
  };
}
