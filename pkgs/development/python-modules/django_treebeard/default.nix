{ stdenv
, buildPythonPackage
, fetchPypi
, pytest
, django
}:

buildPythonPackage rec {
  pname = "django-treebeard";
  version = "4.3.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "83aebc34a9f06de7daaec330d858d1c47887e81be3da77e3541fe7368196dd8a";
  };

  buildInputs = [ pytest ];
  propagatedBuildInputs = [ django ];

  # tests fail  "AppRegistryNotReady("Apps aren't loaded yet.")"
  doCheck = false;

  meta = with stdenv.lib; {
    description = "Efficient tree implementations for Django 1.6+";
    homepage = https://tabo.pe/projects/django-treebeard/;
    maintainers = with maintainers; [ desiderius ];
    license = licenses.asl20;
  };

}
