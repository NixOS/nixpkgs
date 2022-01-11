{ lib
, buildPythonPackage
, fetchFromGitHub
, pbr
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "icmplib";
  version = "3.0.2";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ValentinBELYN";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-4aq89Nw55OL7JQx3Ra6Ppp5yKLdS6Lc0YA8UJxVhz84=";
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
