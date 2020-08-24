{ lib
, buildPythonPackage
, fetchPypi
, psycopg2
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

  # psycopg2cffi is compatible with psycopg2 and author states that
  # module is compatible with psycopg2
  postConfigure = ''
    substituteInPlace setup.py \
      --replace "psycopg2cffi" "psycopg2"

    substituteInPlace pq/tests.py \
      --replace "psycopg2cffi" "psycopg2"
  '';

  checkInputs = [
    psycopg2
  ];

  # tests require running postgresql cluster
  doCheck = false;

  meta = with lib; {
    description = "PQ is a transactional queue for PostgreSQL";
    homepage = https://github.com/malthe/pq/;
    license = licenses.bsd3;
    maintainers = [ maintainers.costrouc ];
  };
}
