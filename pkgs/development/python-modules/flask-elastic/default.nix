{
  lib,
  buildPythonPackage,
  fetchPypi,
  flask,
  elasticsearch,
}:

buildPythonPackage rec {
  pname = "flask-elastic";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    pname = "Flask-Elastic";
    inherit version;
    hash = "sha256-XwGm/FQbXSV2qbAlHyAbT4DLcQnIseDm1Qqdb5zjE0M=";
  };

  propagatedBuildInputs = [
    flask
    elasticsearch
  ];
  doCheck = false; # no tests

  meta = {
    description = "Integrates official client for Elasticsearch into Flask";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.mic92 ];
    homepage = "https://github.com/marceltschoppch/flask-elastic";
  };
}
