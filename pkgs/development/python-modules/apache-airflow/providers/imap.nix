{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "apache-airflow-providers-imap";
  version = "2.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-xxo4SsiaLmkw/uG8hdHiQVJMDV/3/g1ZNlNiy7NbUIg=";
  };

  meta = with lib; {
    homepage = "http://airflow.apache.org/";
    license = licenses.asl20;
  };
}
