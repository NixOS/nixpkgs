{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "drf-spectacular-sidecar";
  version = "2026.9.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular-sidecar";
    tag = finalAttrs.version;
    hash = "sha256-fjrXNUR2IyMrK2ZmaxbSkjCSfoIr82x6y83OxZQFD4k=";
  };

  build-system = [ setuptools ];

  dependencies = [ django ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "drf_spectacular_sidecar" ];

  meta = {
    description = "Serve self-contained distribution builds of Swagger UI and Redoc with Django";
    homepage = "https://github.com/tfranzel/drf-spectacular-sidecar";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
