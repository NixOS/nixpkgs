{ lib, stdenv
, buildPythonPackage
, fetchPypi
, pytest
, django
}:

buildPythonPackage rec {
  pname = "django-treebeard";
  version = "4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f50e4eea146f7af6702decf7ef198ac1eee1fb9bb4af2c5dba276c3c48f76623";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ django ];

  # tests fail  "AppRegistryNotReady("Apps aren't loaded yet.")"
  doCheck = false;

  meta = with lib; {
    description = "Efficient tree implementations for Django 1.6+";
    homepage = "https://tabo.pe/projects/django-treebeard/";
    maintainers = with maintainers; [ desiderius ];
    license = licenses.asl20;
  };

}
