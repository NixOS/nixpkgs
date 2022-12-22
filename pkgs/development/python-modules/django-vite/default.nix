{ lib, fetchFromGitHub, buildPythonPackage, django }:

buildPythonPackage rec {
  pname = "django-vite";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "MrBin99";
    repo = pname;
    rev = version;
    sha256 = "sha256-lYRFNHTIQBn7CDnWFxSzXELzqEtQcbwHedSZnR7ZtbE=";
  };

  propagatedBuildInputs = [ django ];

  # Package doesn’t have any tests
  doCheck = false;

  pythonImportsCheck = [ "django_vite" ];

  meta = with lib; {
    description = " Integration of ViteJS in a Django project.";
    homepage = "https://github.com/MrBin99/django-vite";
    license = licenses.asl20;
    maintainers = with maintainers; [ sephi ];
  };
}
