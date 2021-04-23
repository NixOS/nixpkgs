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
  version = "2.1.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ValentinBELYN";
    repo = pname;
    rev = "v${version}";
    sha256 = "06xx9854yzxa7x1mjfzbhhw5rfzgjnw269j5k0rshyqh3qvw1nwv";
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
