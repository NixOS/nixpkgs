{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
}:

buildPythonPackage rec {
  pname = "connection-pool";
  version = "0.0.3";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    pname = "connection_pool";
    inherit version;
    sha256 = "bf429e7aef65921c69b4ed48f3d48d3eac1383b05d2df91884705842d974d0dc";
  };

  doCheck = false; # no tests
  pythonImportsCheck = [ "connection_pool" ];

  meta = with lib; {
    description = "Thread-safe connection pool";
    homepage = "https://github.com/zhouyl/ConnectionPool";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ veprbl ];
  };
}
