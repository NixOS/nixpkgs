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
    sha256 = "58934a06a6932696e54c9e8af3fab49bf67ca9e9c840ad668cb7f51219808a07";
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
