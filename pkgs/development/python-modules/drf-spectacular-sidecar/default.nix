{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "drf-spectacular-sidecar";
<<<<<<< HEAD
  version = "2025.12.1";
=======
  version = "2025.8.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular-sidecar";
<<<<<<< HEAD
    tag = version;
    hash = "sha256-OPUTLI/BZTATa3f2RwoM0LbDKWXUCBEKtkTgG8OUgTI=";
=======
    rev = version;
    hash = "sha256-H2eHFX7VG7YqLztEV/G4QnVYytkfADeHxgBTRlmKt50=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "drf_spectacular_sidecar" ];

<<<<<<< HEAD
  meta = {
    description = "Serve self-contained distribution builds of Swagger UI and Redoc with Django";
    homepage = "https://github.com/tfranzel/drf-spectacular-sidecar";
    license = lib.licenses.bsd3;
=======
  meta = with lib; {
    description = "Serve self-contained distribution builds of Swagger UI and Redoc with Django";
    homepage = "https://github.com/tfranzel/drf-spectacular-sidecar";
    license = licenses.bsd3;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
  };
}
