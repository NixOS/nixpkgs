{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  django-jinja,
  python,
}:

buildPythonPackage rec {
  pname = "django-sites";
  version = "0.11";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "niwinz";
    repo = "django-sites";
    rev = version;
    hash = "sha256-MQtQC+9DyS1ICXXovbqPpkKIQ5wpuJDgq3Lcd/1kORU=";
  };

  propagatedBuildInputs = [ django ];

  nativeCheckInputs = [ django-jinja ];

  checkPhase = ''
    runHook preCheck

    ${python.interpreter} runtests.py

    runHook postCheck
  '';

  meta = {
    description = "Alternative implementation of django sites framework";
    homepage = "https://github.com/niwinz/django-sites";
    license = lib.licenses.bsd3;
    # has not been updated for django>=4.0
    broken = lib.versionAtLeast django.version "4";
  };
}
