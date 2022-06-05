{ lib
, buildPythonPackage
, fetchPypi
, pytest
, django
}:

buildPythonPackage rec {
  pname = "django-treebeard";
  version = "4.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "80150017725239702054e5fa64dc66e383dc13ac262c8d47ee5a82cb005969da";
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
