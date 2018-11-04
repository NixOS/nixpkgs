{ stdenv
, buildPythonPackage
, fetchPypi
, django
}:

buildPythonPackage rec {
  pname = "django-reversion";
  version = "3.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "98cb09c2227b14a0f88faaf4f747a716a5b1f183768959fe6035cbc12c3adbfe";
  };

  propagatedBuildInputs = [ django ];

  meta = with stdenv.lib; {
    description = "An extension to the Django web framework that provides comprehensive version control facilities";
    homepage = https://github.com/etianen/django-reversion;
    license = licenses.bsd3;
  };

}
