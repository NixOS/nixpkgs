{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "django-gravatar2";
  version = "1.4.5";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-LbtWRl45Xdizkg1AF+J6R1aRLMKtmxG6SM8UOHGoA2Q=";
  };

  doCheck = false;

  meta = with lib; {
    description = "Essential Gravatar support for Django";
    homepage = "https://github.com/twaddington/django-gravatar";
    license = licenses.mit;
  };
}
