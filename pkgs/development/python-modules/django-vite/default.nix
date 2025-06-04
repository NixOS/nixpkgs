{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  django,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "django-vite";
  version = "3.1.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

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

  meta = with lib; {
    description = "Integration of ViteJS in a Django project";
    homepage = "https://github.com/MrBin99/django-vite";
    changelog = "https://github.com/MrBin99/django-vite/releases/tag/${src.tag}";
    license = licenses.asl20;
    maintainers = with maintainers; [ sephi ];
  };
}
