{ lib, buildPythonPackage, fetchPypi
, django, futures }:

buildPythonPackage rec {
  pname = "django-pipeline";
  version = "1.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1y49fa8jj7x9qjj5wzhns3zxwj0s73sggvkrv660cqw5qb7d8hha";
  };

  propagatedBuildInputs = [ django futures ];

  meta = with lib; {
    description = "Pipeline is an asset packaging library for Django";
    homepage = https://github.com/cyberdelia/django-pipeline;
    license = licenses.mit;
  };
}
