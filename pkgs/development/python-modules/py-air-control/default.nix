{ buildPythonPackage, coapthon3, fetchFromGitHub, isPy27, lib, pycryptodomex }:

buildPythonPackage rec {
  pname = "py-air-control";
  version = "2.1.0";
  format = "setuptools";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "rgerganov";
    repo = pname;
    rev = "v${version}";
    sha256 = "0mkggl5hwmj90djxbbz4svim6iv7xl8k324cb4rlc75p5rgcdwmh";
  };

  propagatedBuildInputs = [ pycryptodomex coapthon3 ];

  # tests sometimes hang forever on tear-down
  doCheck = false;
  pythonImportsCheck = [ "pyairctrl" ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Command Line App for Controlling Philips Air Purifiers.";
    license = licenses.mit;
    maintainers = with maintainers; [ urbas ];
  };
}
