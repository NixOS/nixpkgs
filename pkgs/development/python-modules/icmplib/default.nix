{ lib
, buildPythonPackage
, fetchFromGitHub
, pbr
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "icmplib";
  version = "3.0.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ValentinBELYN";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-i5cmL8kOrehldOwX2RfVAfL4HdzJ+9S3BojJI2raUSA=";
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
