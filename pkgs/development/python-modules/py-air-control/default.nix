{
  lib,
  buildPythonPackage,
  coapthon3,
  fetchFromGitHub,
  pycryptodomex,
  setuptools,
}:

buildPythonPackage rec {
  pname = "py-air-control";
  version = "2.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "rgerganov";
    repo = "py-air-control";
    tag = "v${version}";
    hash = "sha256-3Qk1cmF31vJhUEckjfbYM9IDgD+gVkZtQlXel8iP/b8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pycryptodomex
    coapthon3
  ];

  # tests sometimes hang forever on tear-down
  doCheck = false;

  pythonImportsCheck = [ "pyairctrl" ];

  meta = with lib; {
    description = "Command Line App for Controlling Philips Air Purifiers";
    homepage = "https://github.com/rgerganov/py-air-control";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
