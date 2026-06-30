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
  msgspec,
  pydantic,
  pydantic-extra-types,
  email-validator,
  pyjwt,
  cryptography,
  openapi-spec-validator,
  polyfactory,
  pyyaml,
  attrs,

  # tests
  dirty-equals,
  django-csp,
  faker,
  freezegun,
  inline-snapshot,
  orjson,
  phonenumbers,
  punq,
  pytestCheckHook,
  pytest-asyncio,
  pytest-django,
  pytest-freezer,
  pytest-randomly,
  syrupy,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "django-modern-rest";
  version = "0.9.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "django-modern-rest";
    tag = version;
    hash = "sha256-MmCU++g23wYhZ2KVcmIUoJipGXAyIBGJa5lPuAm6eAA=";
  };

  postPatch = ''
    # xmltodict-rs is not packaged in nixpkgs; xmltodict is API-compatible
    # for the parse/unparse calls used here.
    substituteInPlace \
      tests/infra/xml_format.py \
      django_test_app/server/apps/negotiations/views.py \
      --replace-fail "import xmltodict_rs as xmltodict" "import xmltodict"
  '';

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    django
    typing-extensions
  ];

  optional-dependencies = {
    # upstream pins `msgspec>=0.21.1`; nixpkgs ships 0.20.0. The plugin's
    # runtime module passes `ref_template` (added in 0.21) when generating
    # JSON schema, so the affected test paths are listed below in
    # `disabledTestPaths`. The remaining msgspec tests still pass on 0.20.
    msgspec = [ msgspec ];
    # upstream declares `pydantic[email,timezone]>=2.12`. `[email]` pulls
    # in `email-validator` for `pydantic.EmailStr`; `[timezone]` is
    # Windows-only `tzdata` and is not needed on Linux/Darwin.
    pydantic = [
      pydantic
      pydantic-extra-types
      email-validator
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
    # upstream pins `attrs>=26.0` plus `msgspec>=0.21.1`; nixpkgs ships
    # `attrs` 25.4 and `msgspec` 0.20. The single attrs integration test
    # is disabled below until both deps move forward.
    attrs = [
      msgspec
      attrs
    ];
  };

  nativeCheckInputs = [
    dirty-equals
    django-csp
    faker
    freezegun
    inline-snapshot
    orjson
    phonenumbers
    punq
    pytestCheckHook
    pytest-asyncio
    pytest-django
    pytest-freezer
    pytest-randomly
    syrupy
    xmltodict
  ]
  ++ optional-dependencies.msgspec
  ++ optional-dependencies.pydantic
  ++ optional-dependencies.jwt
  ++ optional-dependencies.openapi
  ++ optional-dependencies.attrs;

  pytestFlags = [
    # remove coverage / tracecov flags from pyproject.toml
    "--override-ini"
    "addopts="
  ];

  disabledTestPaths = [
    # benchmarks need extra build deps and aren't real test targets
    "benchmarks"
    # type safety tests require mypy/pyright, not runtime tests
    "typesafety"
    # schema validation tests require schemathesis which is not in nixpkgs
    "tests/test_unit/test_openapi/test_schema_validation.py"
    "tests/test_integration/test_openapi"
    # require pydantic-extra-types >= 2.12 (re-exports `Color` at top level);
    # nixpkgs ships 2.11.x where `Color` lives in `pydantic_extra_types.color`
    "tests/test_unit/test_plugins/test_pydantic/test_complex_pydantic_fields.py"
    "tests/test_unit/test_plugins/test_pydantic/test_pydantic_dataclasses.py"
    "tests/test_unit/test_plugins/test_pydantic/test_pydantic_snapshots.py"
    # require msgspec >= 0.21 (uses `ref_template` kw); nixpkgs ships 0.20
    "tests/test_unit/test_plugins/test_msgspec/test_msgspec_schema.py"
    "tests/test_unit/test_plugins/test_msgspec/test_msgspec_snapshots.py"
    "tests/test_unit/test_plugins/test_msgspec/test_msgspec_schema_errors.py"
    "tests/test_unit/test_plugins/test_msgspec/test_msgpack.py"
    "tests/test_unit/test_plugins/test_msgspec/test_attrs.py"
  ];

  disabledTests = [
    # snapshot expects xmltodict-rs output format; xmltodict differs slightly
    "test_sse_negotiation"
    # snapshot reorders schema title/description differently across versions
    "test_sse_schema"
    # error message for invalid XML differs between xmltodict (expat) and
    # xmltodict-rs ("unclosed token" vs "unclosed element(s) found")
    "test_negotiation_invalid_xml"
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
