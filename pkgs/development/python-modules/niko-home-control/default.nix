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
  version = "0.3.0";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "NoUseFreak";
    repo = pname;
    rev = version;
    sha256 = "sha256-n/uQAX2LgxeGTRF56+G5vm5wbeTQQQODV4EKaPgKw1k=";
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
