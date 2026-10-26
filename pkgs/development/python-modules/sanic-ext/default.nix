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

buildPythonPackage (finalAttrs: {
  pname = "sanic-ext";
  version = "25.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sanic-org";
    repo = "sanic-ext";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h1yN5VYFPFUZoeZeJ6+CfGE3m/5zz+/G3BbetDKtZAo=";
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
    changelog = "https://github.com/sanic-org/sanic-ext/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ p0lyw0lf ];
  };
})
