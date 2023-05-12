{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  attrs,
  httpx,
  poetry-core,
  python-dateutil,
}:

buildPythonPackage rec {
  pname = "openapi-python-client-integration-tests";
  version = "0.14.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "openapi-generators";
    repo = "openapi-python-client";
    rev = "v${version}";
    hash = "sha256-Etw0Iz5aAdu/K+WSmue9ux8qi0f/YKgZgVhqCbGVxE0=";
  };

  sourceRoot = "source/integration-tests";

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "poetry.masonry.api" "poetry.core.masonry.api"
  '';

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    attrs
    httpx
    python-dateutil
  ];

  meta = {
    changelog = "https://github.com/openapi-generators/openapi-python-client/blob/${src.rev}/CHANGELOG.md";
    description = "Integration Tests subpackage of OpenAPI Python Client";
    homepage = "https://github.com/openapi-generators/openapi-python-client";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.drupol ];
  };
}
