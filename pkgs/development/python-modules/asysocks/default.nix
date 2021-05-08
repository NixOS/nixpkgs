{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "asysocks";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-7EzSALAJcx8BNHX44FeeiSPRcTe9UFHXQ4IoSKxMU8w=";
  };

  # Upstream hasn't release the tests yet
  doCheck = false;
  pythonImportsCheck = [ "asysocks" ];

  meta = with lib; {
    description = "Python Socks4/5 client and server library";
    homepage = "https://github.com/skelsec/asysocks";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
