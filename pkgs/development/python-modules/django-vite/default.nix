{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  django,
}:

buildPythonPackage rec {
  pname = "django-vite";
  version = "3.2.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MrBin99";
    repo = "django-vite";
    tag = version;
    hash = "sha256-uC8Q0SA6V5Dhy5P5CzDlkC145stY3MabNsrrWVM934I=";
  };

  propagatedBuildInputs = [ django ];

  # Package doesn’t have any tests
  doCheck = false;

  pythonImportsCheck = [ "django_vite" ];

  meta = {
    description = "Integration of ViteJS in a Django project";
    homepage = "https://github.com/MrBin99/django-vite";
    changelog = "https://github.com/MrBin99/django-vite/releases/tag/${src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sephi ];
  };
}
