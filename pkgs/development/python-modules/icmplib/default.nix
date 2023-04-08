{ lib
, buildPythonPackage
, fetchFromGitHub
, pbr
, pythonOlder
, requests
}:

buildPythonPackage rec {
  pname = "icmplib";
  version = "3.0.3";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "ValentinBELYN";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-EQyu7lV8F/U8cZklYYIMk9ut1FTcoBvGc8Ggx6JerDk=";
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
