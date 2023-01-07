{ lib
, buildPythonPackage
, fetchPypi
, pytest
, django
}:

buildPythonPackage rec {
  pname = "django-treebeard";
  version = "4.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-frHrcbJCFPLn3DvSFfDDrjL9Z2QXnNR3SveqtJE53qA=";
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
