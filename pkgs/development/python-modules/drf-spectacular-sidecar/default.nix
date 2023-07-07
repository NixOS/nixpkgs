{ lib
, buildPythonPackage
, fetchFromGitHub
, django
}:

buildPythonPackage rec {
  pname = "drf-spectacular-sidecar";
  version = "2023.3.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular-sidecar";
    rev = version;
    hash = "sha256-UTH6t/znN4nYnqDhtFFxXoBXX8Zo19pJE9iDsvw7bGE=";
  };

  propagatedBuildInputs = [
    django
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "drf_spectacular_sidecar" ];

  meta = with lib; {
    description = "Serve self-contained distribution builds of Swagger UI and Redoc with Django";
    homepage = "https://github.com/tfranzel/drf-spectacular-sidecar";
    license = licenses.bsd3;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
