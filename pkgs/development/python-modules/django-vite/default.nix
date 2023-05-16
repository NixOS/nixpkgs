{ lib
, fetchFromGitHub
, buildPythonPackage
, django
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-vite";
<<<<<<< HEAD
  version = "2.1.3";
=======
  version = "2.0.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MrBin99";
    repo = pname;
    rev = "refs/tags/${version}";
<<<<<<< HEAD
    hash = "sha256-HrcQt0Mdko+/XJd0srQTBYMtHaLZyImMuQn39HIwDfY=";
=======
    hash = "sha256-lYRFNHTIQBn7CDnWFxSzXELzqEtQcbwHedSZnR7ZtbE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = [
    django
  ];

  # Package doesn’t have any tests
  doCheck = false;

  pythonImportsCheck = [
    "django_vite"
  ];

  meta = with lib; {
    description = "Integration of ViteJS in a Django project";
    homepage = "https://github.com/MrBin99/django-vite";
    changelog = "https://github.com/MrBin99/django-vite/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ sephi ];
  };
}
