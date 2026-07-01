{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "pq";
  version = "1.9.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-1krw77ij69EbLg5mKmQmxeHpn38uRG9EOboGmRk+StY=";
  };

  # tests require running postgresql cluster
  doCheck = false;
  pythonImportsCheck = [ "pq" ];

  meta = {
    description = "PQ is a transactional queue for PostgreSQL";
    homepage = "https://github.com/malthe/pq/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
