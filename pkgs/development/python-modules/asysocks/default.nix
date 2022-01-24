{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "asysocks";
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1hi9hzih265qlh7x32r5pbaqm9wkhm52yrdiksnd4gl5nrdgwcwv";
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
