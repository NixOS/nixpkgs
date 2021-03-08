{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "asysocks";
  version = "0.0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "11ygrhkqm524i4qp2myjvpsmg1lsn32nsqxqla96sbj84qfnhv0q";
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
