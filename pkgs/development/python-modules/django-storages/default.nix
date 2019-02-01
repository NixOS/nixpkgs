{ stdenv, lib, buildPythonPackage, isPyPy, fetchFromGitHub
, django }:

buildPythonPackage rec {
  pname = "django-storages";
  version = "1.7.1";

  disabled = isPyPy;

  src = fetchFromGitHub {
    owner = "jschneier";
    repo = pname;
    rev = version;
    sha256 = "0jcsh311af1yh5g9p79k27594wrjypphmdrabwv6nnjmwqb4igzg";
  };

  propagatedBuildInputs = [ django ];

  # django.core.exceptions.ImproperlyConfigured
  doCheck = false;

  meta = with lib; {
    description = "Provide a variety of Django storage backends";
    homepage = https://github.com/jschneier/django-storages;
    maintainers = with maintainers; [ Krajiyah ];
    # license = with licenses; [ ??? ]; # not sure what license that is
  };
}
