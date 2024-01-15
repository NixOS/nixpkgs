{ lib
, fetchFromGitHub
, buildPythonPackage
, django
, pythonOlder
}:

buildPythonPackage rec {
  pname = "django-vite";
  version = "3.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "MrBin99";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Lnecxkn+E1Bce/EhP1AHH9/VrdzBiMGLv+eYld5+QKM=";
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
