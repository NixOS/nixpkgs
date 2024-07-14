{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "django-gravatar2";
  version = "1.4.4";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-yBMoCWdRHO2T7qA1n2DlNpw1szEe/lZcPl1Ks1wQye4=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Essential Gravatar support for Django";
    homepage = "https://github.com/twaddington/django-gravatar";
    license = licenses.mit;
  };
}
