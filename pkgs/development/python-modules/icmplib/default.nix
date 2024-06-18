{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pbr,
  pythonOlder,
  requests,
}:

buildPythonPackage rec {
  pname = "icmplib";
  version = "3.0.4";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ValentinBELYN";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-PnBcGiUvftz/KYg9Qd2GaIcF3OW4lYH301uI5/M5CBI=";
  };

  propagatedBuildInputs = [
    pbr
    requests
  ];

  # Project has no tests
  doCheck = false;
  pythonImportsCheck = [ "icmplib" ];

  meta = with lib; {
    description = "Python implementation of the ICMP protocol";
    homepage = "https://github.com/ValentinBELYN/icmplib";
    license = with licenses; [ lgpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
