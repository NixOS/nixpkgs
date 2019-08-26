{ stdenv, buildPythonPackage, fetchPypi, django-gravatar2, django_compressor
, django-allauth, mailmanclient
}:

buildPythonPackage rec {
  pname = "django-mailman3";
  version = "1.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0v6c1jhcc212wc2xa314irfcchl05r7nysrcy63dcaan958kmnnx";
  };

  propagatedBuildInputs = [
    django-gravatar2 django_compressor django-allauth mailmanclient
  ];

  doCheck = false;
}
