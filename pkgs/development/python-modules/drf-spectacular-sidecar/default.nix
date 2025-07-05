{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "drf-spectacular-sidecar";
  version = "2025.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular-sidecar";
    rev = version;
    hash = "sha256-YzSUwShj7QGCVKlTRM2Gro38Y+jGYQsMGBMAH0radmA=";
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
