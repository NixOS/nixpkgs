{ stdenv, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-polymorphic";
  version = "1.3";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8737b465ebf5fad772b4c52272189c352f5904f468d298584a3469187e3207ad";
  };

  checkInputs = [ django ];
  propagatedBuildInputs = [ django ];

  meta = {
    homepage = https://github.com/django-polymorphic/django-polymorphic;
    description = "Improved Django model inheritance with automatic downcasting";
    license = stdenv.lib.licenses.bsd3;
  };
}
