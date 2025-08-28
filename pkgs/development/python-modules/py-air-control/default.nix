{
  buildPythonPackage,
  coapthon3,
  fetchFromGitHub,
  isPy27,
  lib,
  pycryptodomex,
}:

buildPythonPackage rec {
  pname = "py-air-control";
  version = "2.3.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rgerganov";
    repo = "py-air-control";
    rev = "v${version}";
    sha256 = "sha256-3Qk1cmF31vJhUEckjfbYM9IDgD+gVkZtQlXel8iP/b8=";
  };

  propagatedBuildInputs = [
    pycryptodomex
    coapthon3
  ];

  # tests sometimes hang forever on tear-down
  doCheck = false;
  pythonImportsCheck = [ "pyairctrl" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Command Line App for Controlling Philips Air Purifiers";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
