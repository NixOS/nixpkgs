{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "pq";
  version = "1.8.2";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f54143844e73f4182532e68548dee447dd78dd00310a087e8cdee756d476a173";
  };

  # tests require running postgresql cluster
  doCheck = false;
  pythonImportsCheck = [ "pq" ];

  meta = with lib; {
    description = "PQ is a transactional queue for PostgreSQL";
    homepage = https://github.com/malthe/pq/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
