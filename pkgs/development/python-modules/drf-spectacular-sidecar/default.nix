{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  django,
  setuptools,
}:

buildPythonPackage rec {
  pname = "drf-spectacular-sidecar";
  version = "2026.1.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tfranzel";
    repo = "drf-spectacular-sidecar";
    tag = version;
    hash = "sha256-8+KfFyGcwA99mSZi95uOqOqzcJUa1GXu0BYva+hJDOw=";
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
}
