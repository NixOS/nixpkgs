{ stdenv, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-polymorphic";
  version = "1.2";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1bz86711sx2b66rl2xz141xppsfmlxilkgjgq0jsavpw37vg7r3r";
  };

  checkInputs = [ django ];
  propagatedBuildInputs = [ django ];

  meta = {
    homepage = https://github.com/django-polymorphic/django-polymorphic;
    description = "Improved Django model inheritance with automatic downcasting";
    license = stdenv.lib.licenses.bsd3;
  };
}
