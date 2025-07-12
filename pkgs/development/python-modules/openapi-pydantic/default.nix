{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pydantic,
}:

buildPythonPackage rec {
  pname = "openapi-pydantic";
  version = "0.5.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mike-oakley";
    repo = "openapi-pydantic";
    rev = "v${version}";
    hash = "sha256-SMAjzHGuu+QVWe/y8jQ4UWJI9f+pLR2BxgjvE6vOT0Q=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    pydantic
  ];

  pythonImportsCheck = [
    "openapi_pydantic"
  ];

  meta = {
    description = "Pydantic OpenAPI schema implementation";
    homepage = "https://github.com/mike-oakley/openapi-pydantic";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ taha-yassine ];
  };
}
