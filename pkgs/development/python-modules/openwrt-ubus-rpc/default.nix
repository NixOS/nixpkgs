{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
  urllib3,
}:

buildPythonPackage rec {
  pname = "openwrt-ubus-rpc";
  version = "0.0.3";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "Noltari";
    repo = "python-ubus-rpc";
    tag = version;
    hash = "sha256-M4hbnGrAjBjohwgMf6qw5NQnpyKCZ0/4HVklHhizTKc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    requests
    urllib3
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "openwrt.ubus" ];

  meta = {
    description = "Python API for OpenWrt ubus RPC";
    homepage = "https://github.com/Noltari/python-ubus-rpc";
    changelog = "https://github.com/Noltari/python-ubus-rpc/releases/tag/${version}";
    license = with lib.licenses; [ gpl2Only ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
