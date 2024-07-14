{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "django-paintstore";
  version = "0.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-j3MmV28GGOTwONWD27VgpZjdojp1nVj4wW4uHDZ/nYs=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Django app that integrates jQuery ColorPicker with the Django admin";
    homepage = "https://github.com/gsiegman/django-paintstore";
    license = licenses.mit;
  };
}
