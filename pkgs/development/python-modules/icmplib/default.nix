{ lib
, buildPythonPackage
, fetchFromGitHub
, pbr
, pythonOlder
, requests
, six
}:

buildPythonPackage rec {
  pname = "icmplib";
  version = "2.0.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ValentinBELYN";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vps4iz87f8l0z3va92srsx5v19nnd65c22hvbgvhag3vhqsxg7h";
  };

  propagatedBuildInputs = [
    pbr
    six
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
