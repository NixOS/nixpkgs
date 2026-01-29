{
  buildPythonPackage,
  django,
  lib,
  fetchurl,
  setuptools-scm,
  pythonOlder,
}:
buildPythonPackage {
  pname = "django-sslserver";
  version = "0.22";
  format = "wheel";

  src = fetchurl {
    url = "https://files.pythonhosted.org/packages/6f/97/e4011f3944f83a7d2aaaf893c3689ad70e8d2ae46fb6e14fd0e3b0c6ce0b/django_sslserver-0.22-py3-none-any.whl";
    hash = "sha256-xZijY9LM3CQhwI3bPYsJc/gOjkejpbdOSiiW8hwpR8U=";
  };

  disabled = pythonOlder "3.4";

  dependencies = [
    django
  ];

  build-system = [ setuptools-scm ];
  doCheck = true;

  meta = with lib; {
    description = "A SSL-enabled development server for Django";
    homepage = "https://github.com/teddziuba/django-sslserver";
    license = licenses.mit;
    maintainers = with maintainers; [ kurogeek ];
  };
}
