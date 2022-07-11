{ lib
, buildPythonPackage
, fetchPypi
, requests
}:

buildPythonPackage rec {
  pname = "apache-airflow-providers-http";
  version = "2.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-XwQia81WJwN9PpA9ywwLdEztyQP2jX7tolw36NbSbzY=";
  };

  propagatedBuildInputs = [
    requests
  ];

  meta = with lib; {
    homepage = "http://airflow.apache.org/";
    license = licenses.asl20;
  };
}
