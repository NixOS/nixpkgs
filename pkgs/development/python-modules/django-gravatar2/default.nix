{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
}:

buildPythonPackage rec {
  pname = "django-gravatar2";
  version = "1.4.5";
  pyproject = true;

  src = fetchPypi {
    pname = "django_gravatar2";
    inherit version;
    hash = "sha256-LbtWRl45Xdizkg1AF+J6R1aRLMKtmxG6SM8UOHGoA2Q=";
  };

  build-system = [ setuptools ];

  doCheck = false;

  pythonImportsCheck = [ "django_gravatar" ];

  meta = with lib; {
    description = "Essential Gravatar support for Django";
    homepage = "https://github.com/twaddington/django-gravatar";
    license = licenses.mit;
  };
}
