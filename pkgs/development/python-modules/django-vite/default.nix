{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  django,
}:

buildPythonPackage rec {
  pname = "django-vite";
  version = "3.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "MrBin99";
    repo = "django-vite";
    tag = version;
    hash = "sha256-S5DpU0Sw0TOY1SNici6djeTrvg4gehH/a2UCzju1e/s=";
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
