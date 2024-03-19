{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "pq";
  version = "1.9.1";
  format = "setuptools";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1krw77ij69EbLg5mKmQmxeHpn38uRG9EOboGmRk+StY=";
  };

  # tests require running postgresql cluster
  doCheck = false;
  pythonImportsCheck = [ "pq" ];

  meta = with lib; {
    description = "PQ is a transactional queue for PostgreSQL";
    homepage = "https://github.com/malthe/pq/";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
