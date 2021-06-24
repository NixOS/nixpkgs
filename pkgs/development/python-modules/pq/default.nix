{ lib
, buildPythonPackage
, fetchPypi
, isPy27
}:

buildPythonPackage rec {
  pname = "pq";
  version = "1.9.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "c664ee3a9a25efcb583e3d1d797588fb7c2fb5096220689eec78a7946b01b5ff";
  };

  # tests require running postgresql cluster
  doCheck = false;
  pythonImportsCheck = [ "pq" ];

  meta = with lib; {
    description = "PQ is a transactional queue for PostgreSQL";
    homepage = "https://github.com/malthe/pq/";
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
