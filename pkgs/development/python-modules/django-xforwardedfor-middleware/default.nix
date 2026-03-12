{
  buildPythonPackage,
  django,
  fetchFromGitHub,
  lib,
  setuptools,
}:
buildPythonPackage rec {
  pname = "django-xforwardedfor-middleware";
  version = "2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "allo-";
    repo = "django-xforwardedfor-middleware";
    tag = "v${version}";
    hash = "sha256-dDXSb17kXOSeIgY6wid1QFHhUjrapasWgCEb/El51eA=";
  };

  dependencies = [
    django
  ];

  build-system = [ setuptools ];
  doCheck = true;

  meta = with lib; {
    description = "Use the X-Forwarded-For header to get the real ip of a request";
    homepage = "https://github.com/allo-/django-xforwardedfor-middleware";
    license = licenses.publicDomain;
    maintainers = with maintainers; [ kurogeek ];
  };
}
