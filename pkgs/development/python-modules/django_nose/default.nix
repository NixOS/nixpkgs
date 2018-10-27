{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, django
}:

buildPythonPackage rec {
  pname = "django-nose";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fm47fkza2lk0xgc6qpi9vs78zg7q8cgl6mdan69sbycgy909ff0";
  };

  # vast dependency list
  doCheck = false;

  propagatedBuildInputs = [ django nose ];

  meta = with stdenv.lib; {
    description = "Provides all the goodness of nose in your Django tests";
    homepage = https://github.com/django-nose/django-nose;
    license = licenses.bsd3;
  };

}
