{ stdenv, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-tagging";
  version = "0.4.6";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "210b32af8372b8f68f261fdb7394075669222608d1e6a3bbf2031d59c826eb68";
  };

  # error: invalid command 'test'
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = {
    description = "A generic tagging application for Django projects";
    homepage = https://github.com/Fantomas42/django-tagging;
  };
}
