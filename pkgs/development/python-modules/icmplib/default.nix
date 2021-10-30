{ lib
, buildPythonPackage
, fetchFromGitHub
, pbr
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "icmplib";
  version = "3.0.1";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ValentinBELYN";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-avCy/s54JOeHf6py4sPDV+QC2oq2AU6A6J2YOnrQsm0=";
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
