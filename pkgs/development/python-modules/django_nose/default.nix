{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, django
}:

buildPythonPackage rec {
  pname = "django-nose";
  version = "1.4.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "01wah0ci5xdpiikash68x6lprxlvnkxg72ly9kjrc9lklq34m4sq";
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
