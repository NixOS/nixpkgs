{ lib
, buildPythonPackage
, fetchFromGitHub
, nclib
, netaddr
, netifaces
, pythonOlder
}:

buildPythonPackage rec {
  pname = "niko-home-control";
  version = "0.2.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "NoUseFreak";
    repo = pname;
    rev = version;
    sha256 = "0ah02dfnnbk98grvd180fp9rak5gpi58xiql1yyzig5pcbjidvk3";
  };

  propagatedBuildInputs = [
    nclib
    netaddr
    netifaces
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "nikohomecontrol"
  ];

  meta = with lib; {
    description = "Python SDK for Niko Home Control";
    homepage = "https://github.com/NoUseFreak/niko-home-control";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
