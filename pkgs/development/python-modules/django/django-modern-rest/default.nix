{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,

  # build-system
  hatchling,
  hatch-fancy-pypi-readme,

  # dependencies
  django,
  typing-extensions,

  # optional-dependencies
  attrs,
  cryptography,
  msgspec,
  openapi-spec-validator,
  polyfactory,
  pydantic,
  pydantic-extra-types,
  pyjwt,
  pyyaml,

  # tests
  dirty-equals,
  django-csp,
  faker,
  inline-snapshot,
  orjson,
  pytestCheckHook,
  pytest-asyncio,
  pytest-django,
  pytest-freezer,
  syrupy,
}:

buildPythonPackage rec {
  pname = "django-modern-rest";
  version = "0.8.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "django-modern-rest";
    tag = version;
    hash = "sha256-qmuMYnyeEk3wCQvQQMrIZ7PN+lSc11x+PcIyLed60H4=";
  };

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    django
    typing-extensions
  ];

  optional-dependencies = {
    msgspec = [ msgspec ];
    pydantic = [
      pydantic
      pydantic-extra-types
    ];
    jwt = [
      pyjwt
      cryptography
    ];
    openapi = [
      openapi-spec-validator
      polyfactory
      pyyaml
    ];
    attrs = [
      msgspec
      attrs
    ];
  };

  nativeCheckInputs = [
    dirty-equals
    django-csp
    faker
    inline-snapshot
    orjson
    pytestCheckHook
    pytest-asyncio
    pytest-django
    pytest-freezer
    syrupy
  ]
  ++ optional-dependencies.msgspec
  ++ optional-dependencies.pydantic
  ++ optional-dependencies.jwt
  ++ optional-dependencies.openapi
  ++ optional-dependencies.attrs;

  pytestFlags = [
    # drop coverage and doctest flags from upstream pyproject.toml
    "--override-ini"
    "addopts="
  ];

  enabledTestPaths = [ "tests/test_unit" ];

  disabledTestPaths = [
    # tests below import xmltodict-rs, which is not packaged in nixpkgs
    "tests/test_unit/test_metadata/test_unsupported_serializer.py"
    "tests/test_unit/test_negotiation/test_breaking_contract.py"
    "tests/test_unit/test_negotiation/test_global_configuration.py"
    "tests/test_unit/test_openapi/test_schema_snapshots.py"
    "tests/test_unit/test_plugins/test_pydantic/test_pydantic_fast.py"
    "tests/test_unit/test_routing/test_not_found_handler.py"
    "tests/test_unit/test_routing/test_server_error_handler.py"
    "tests/test_unit/test_streaming/test_sse/test_sse_settings.py"
    "tests/test_unit/test_throttling/test_throttling_and_parsing.py"
    # tests below need `Color` from pydantic-extra-types (>= 2.12),
    # nixpkgs ships 2.11.x where Color lives in a separate optional extra
    "tests/test_unit/test_plugins/test_pydantic/test_complex_pydantic_fields.py"
    "tests/test_unit/test_plugins/test_pydantic/test_pydantic_dataclasses.py"
    "tests/test_unit/test_plugins/test_pydantic/test_pydantic_snapshots.py"
    # requires msgspec >= 0.21 schema() API (ref_template kw); nixpkgs has 0.20
    "tests/test_unit/test_plugins/test_msgspec/test_msgspec_schema.py"
  ];

  disabledTests = [
    # also require msgspec >= 0.21 schema() API; nixpkgs has 0.20
    "test_attrs_schema"
    "test_msgpack_schema"
    "test_schema_error_contains_original_error"
    "test_user_schema"
    "test_auth_and_cookies_schema"
    "test_file_schema"
    "test_example_schema"
    "test_sse_schema"
  ];

  pythonImportsCheck = [ "dmr" ];

  meta = {
    changelog = "https://github.com/wemake-services/django-modern-rest/releases/tag/${version}";
    description = "Modern REST framework for Django with full type safety and async support";
    homepage = "https://github.com/wemake-services/django-modern-rest";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sesav ];
  };
}
