{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "apache-airflow-providers-ftp";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-qMl8TmnuPbGlQ/IST4QV6VHJo6kDcyG+Bp8s5ZT4qjw=";
  };

  meta = with lib; {
    homepage = "http://airflow.apache.org/";
    license = licenses.asl20;
  };
}
