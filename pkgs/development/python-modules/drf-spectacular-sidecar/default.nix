{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "drf-spectacular-sidecar";
  version = "2025.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular-sidecar";
    rev = version;
    hash = "sha256-H2eHFX7VG7YqLztEV/G4QnVYytkfADeHxgBTRlmKt50=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "drf_spectacular_sidecar" ];

  meta = with lib; {
    description = "Serve self-contained distribution builds of Swagger UI and Redoc with Django";
    homepage = "https://github.com/tfranzel/drf-spectacular-sidecar";
    license = licenses.bsd3;
    maintainers = [ ];
  };
}
