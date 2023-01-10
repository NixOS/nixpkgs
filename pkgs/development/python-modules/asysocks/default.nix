{ lib
, asn1crypto
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "asysocks";
  version = "0.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JHGkQmxt/29GRnVS/GLU1g5Yc+q6voKNOh3n3LfcfcY=";
  };

  propagatedBuildInputs = [
    asn1crypto
  ];

  # Upstream hasn't release the tests yet
  doCheck = false;

  pythonImportsCheck = [
    "asysocks"
  ];

  meta = with lib; {
    description = "Python Socks4/5 client and server library";
    homepage = "https://github.com/skelsec/asysocks";
    changelog = "https://github.com/skelsec/asysocks/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
