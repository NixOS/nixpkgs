{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "apache-airflow-providers-sqlite";
  version = "2.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-rObuSYF6adNT9f9xIFlMDs+udHGnMHh6tmHPFlKNEDw=";
  };

  meta = with lib; {
    homepage = "http://airflow.apache.org/";
    license = licenses.asl20;
  };
}
