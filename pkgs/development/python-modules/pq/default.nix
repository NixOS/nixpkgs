{ lib
, buildPythonPackage
, fetchPypi
, psycopg2
, isPy27
}:

buildPythonPackage rec {
  pname = "pq";
  version = "1.8.1";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e2c0195488263902ebc9da8df6c82bebe4ee32c79d9ecd0cdc2945afbf7ad32";
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
