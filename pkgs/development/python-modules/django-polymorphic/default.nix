{ stdenv, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-polymorphic";
  version = "2.0.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e1821d7b5874509a158a0f22bebf544330e0944c481c5a3e6da6cac8887e4e88";
  };

  checkInputs = [ django ];
  propagatedBuildInputs = [ django ];

  meta = {
    homepage = https://github.com/django-polymorphic/django-polymorphic;
    description = "Improved Django model inheritance with automatic downcasting";
    license = stdenv.lib.licenses.bsd3;
  };
}
