{ stdenv
, buildPythonPackage
, fetchPypi
, nose
, django
}:

buildPythonPackage rec {
  pname = "django-nose";
  version = "1.4.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0sp78839s8yba6vlj9ab4r364skf1s5gzhaar1b1vw15rcc3yrl7";
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
