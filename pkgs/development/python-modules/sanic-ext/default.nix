{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # Build system
  setuptools,

  # Dependencies
  pyyaml,

  # Test dependencies
  pytestCheckHook,

  sanic-testing,
  attrs,
  coverage,
  msgspec,
  pydantic,
  pytest,
  pytest-cov-stub,
  pytest-asyncio,
  tox,
  jinja2,
}:

buildPythonPackage rec {
  pname = "sanic-ext";
  version = "24.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-ext";
    tag = "v${version}";
    hash = "sha256-H1tqiPQ4SwlNGj7GtB2h7noZpU+gbGXIbmRK1TSSqVA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    pyyaml
  ];

  nativeCheckInputs = [
    pytestCheckHook

    sanic-testing
    attrs
    coverage
    msgspec
    pydantic
    pytest
    pytest-cov-stub
    pytest-asyncio
    tox
    jinja2
  ];

  disabledTests = [
    "test_models[FooPydanticDataclass]" # KeyError: 'paths'
    "test_pydantic_base_model[AlertResponsePydanticBaseModel-True]" # AssertionError: assert 'AlertPydanticBaseModel' in {'AlertResponsePydanticBaseModel': ... }
    "test_pydantic_base_model[AlertResponsePydanticDataclass-True]" # AssertionError: assert 'AlertPydanticDataclass' in {'AlertResponsePydanticDataclass': ... }
  ];

  pythonImportsCheck = [ "sanic_ext" ];

  meta = {
    description = "Common, officially supported extension plugins for the Sanic web server framework";
    homepage = "https://github.com/sanic-org/sanic-ext/";
    changelog = "https://github.com/sanic-org/sanic-ext/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ p0lyw0lf ];
  };
}
