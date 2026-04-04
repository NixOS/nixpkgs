{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "icmplib";
  version = "3.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ValentinBELYN";
    repo = "icmplib";
    rev = "v${version}";
    hash = "sha256-PnBcGiUvftz/KYg9Qd2GaIcF3OW4lYH301uI5/M5CBI=";
  };

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "icmplib" ];

  meta = {
    description = "Python implementation of the ICMP protocol";
    homepage = "https://github.com/ValentinBELYN/icmplib";
    license = with lib.licenses; [ lgpl3Plus ];
    maintainers = with lib.maintainers; [ fab ];
  };
}
