{ lib
, buildPythonPackage
, fetchFromGitHub
, django
}:

buildPythonPackage rec {
  pname = "django-cachalot";
  version = "2.5.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "noripyt";
    repo = "django-cachalot";
    rev = "v${version}";
    hash = "sha256-ayAN+PgK3aIpt4R8aeC6c6mRGTnfObycmkoXPTjx4WI=";
  };

  propagatedBuildInputs = [
    django
  ];

  pythonImportsCheck = [ "cachalot" ];

  DJANGO_SETTINGS_MODULE = "settings";

  # Fails with
  # django.core.exceptions.AppRegistryNotReady: Apps aren't loaded yet.
  doCheck = false;

  meta = with lib; {
    description = "No effort, no worry, maximum performance";
    homepage = "https://github.com/noripyt/django-cachalot";
    changelog = "https://github.com/noripyt/django-cachalot/blob/${src.rev}/CHANGELOG.rst";
    license = licenses.bsd3;
    maintainers = with maintainers; [ raitobezarius ];
  };
}
