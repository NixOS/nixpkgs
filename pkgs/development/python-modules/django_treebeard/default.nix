{ lib
, buildPythonPackage
, fetchPypi
, pytest
, django
}:

buildPythonPackage rec {
  pname = "django-treebeard";
  version = "4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8085928debdd187e9919afc522ea40069bb9f090fa804c7ae9a324b0f62843c6";
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
