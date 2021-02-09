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
  version = "2.0.2";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ValentinBELYN";
    repo = pname;
    rev = "v${version}";
    sha256 = "0djsbksgml2h18w6509w59s88730w1xaxdxzws12alq4m5v4hirr";
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
