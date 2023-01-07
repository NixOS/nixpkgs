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
    hash = "sha256-frHrcbJCFPLn3DvSFfDDrjL9Z2QXnNR3SveqtJE53qA=";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ django ];

  # tests fail  "AppRegistryNotReady("Apps aren't loaded yet.")"
  doCheck = false;

  meta = with lib; {
    description = "Efficient tree implementations for Django";
    homepage = "https://tabo.pe/projects/django-treebeard/";
    changelog = "https://github.com/django-treebeard/django-treebeard/blob/${version}/CHANGES.md";
    license = licenses.asl20;
    maintainers = with maintainers; [ desiderius ];
  };
}
