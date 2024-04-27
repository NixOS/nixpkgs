{ lib
, buildPythonPackage
, fetchPypi
, nose
, django
}:

buildPythonPackage rec {
  pname = "django-nose";
  version = "1.4.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a4885cd002d65fd2de96e2bb2563ef477c3fbe207009360c015fca5c3b5561b7";
  };

  # vast dependency list
  doCheck = false;

  propagatedBuildInputs = [ django nose ];

  meta = with lib; {
    description = "Provides all the goodness of nose in your Django tests";
    homepage = "https://github.com/django-nose/django-nose";
    license = licenses.bsd3;
  };

}
