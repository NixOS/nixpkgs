{ lib, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "django-gravatar2";
  version = "1.4.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1vn921fb6jjx7rf5dzhy66rkb71nwmh9ydd0xs9ys72icw4jh4y8";
  };

  doCheck = false;

  meta = with lib; {
    description = "Essential Gravatar support for Django";
    homepage = "https://github.com/twaddington/django-gravatar";
    license = licenses.mit;
  };
}
