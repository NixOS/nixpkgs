{ stdenv, buildPythonPackage, fetchPypi, django }:

buildPythonPackage rec {
  pname = "django-tagging";
  version = "0.4.5";
  name = "${pname}-${version}";

  src = fetchPypi {
    inherit pname version;
    sha256 = "00ki1g6pb2lnaj4lh0s865mmlf4kdwx7a6n38iy5qz9qv4xrvz4q";
  };

  # error: invalid command 'test'
  doCheck = false;

  propagatedBuildInputs = [ django ];

  meta = {
    description = "A generic tagging application for Django projects";
    homepage = https://github.com/Fantomas42/django-tagging;
  };
}
