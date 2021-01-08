{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "asysocks";
  version = "0.0.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1h9awwnn4dr3ppdlnjb4abhyw873n1iddipw6wkwjpw7nnaqqr6i";
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
