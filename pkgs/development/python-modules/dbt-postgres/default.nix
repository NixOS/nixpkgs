{ lib
, fetchPypi
, buildPythonPackage
, pythonOlder
, dbt-core
, psycopg2
}:

buildPythonPackage rec {
  pname = "dbt-postgres";
  version = "1.0.0";

  disabled = pythonOlder "3.7";

  postPatch = ''
    substituteInPlace setup.py \
      --replace "psycopg2-binary" "psycopg2"
  '';

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-eOrEulixIEBx3oTbaaxE3Gg3K2gNo5h5QoJhM48SKZI=";
  };

  propagatedBuildInputs = [
    dbt-core
    psycopg2
  ];

  meta = with lib; {
    description = "Postgres adpter plugin for dbt";
    homepage = "https://getdbt.com";
    license = licenses.asl20;
    maintainers = with maintainers; [ shikanime ];
  };
}
