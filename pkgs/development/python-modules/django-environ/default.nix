{
  lib,
  buildPythonPackage,
  fetchPypi,
  django,
  six,
}:

buildPythonPackage rec {
  pname = "django-environ";
  version = "0.11.2";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8yqHqgiZiUwn1OF3b6a0d+gWTtf2s+QQpiptcsqvZL4=";
  };

  # The testsuite fails to modify the base environment
  doCheck = false;
  propagatedBuildInputs = [
    django
    six
  ];

  meta = with lib; {
    description = "Utilize environment variables to configure your Django application";
    homepage = "https://github.com/joke2k/django-environ/";
    license = licenses.mit;
  };
}
