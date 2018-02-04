{ stdenv, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-polymorphic";
  version = "2.0";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "78f666149ea10cdda08ac6c25ddf4b4e582ee380be87e7968bfed008ef39dfa5";
  };

  checkInputs = [ django ];
  propagatedBuildInputs = [ django ];

  meta = {
    homepage = https://github.com/django-polymorphic/django-polymorphic;
    description = "Improved Django model inheritance with automatic downcasting";
    license = stdenv.lib.licenses.bsd3;
  };
}
