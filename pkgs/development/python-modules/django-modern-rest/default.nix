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
  django-allauth,
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
  pytest-timeout,
  pytest-xdist,
  syrupy,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "django-modern-rest";
  version = "0.14.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "django-modern-rest";
    tag = version;
    hash = "sha256-X5dbfFXOFfMga+ltIywwdToCW/qDU+s0h+1P7YXVD8g=";
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
    allauth = [ django-allauth ];
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
    pytest-timeout
    pytest-xdist
    syrupy
    xmltodict
  ]
  ++ optional-dependencies.msgspec
  ++ optional-dependencies.pydantic
  ++ optional-dependencies.jwt
  ++ optional-dependencies.allauth
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
    # throttling integration tests spin up a redis container via testcontainers
    "tests/test_integration/test_throttling"
    # doc examples are ignored upstream via `addopts`, which we override
    "docs/examples"
    # require pydantic-extra-types >= 2.12 (re-exports `Color` at top level);
    # nixpkgs ships 2.11.x where `Color` lives in `pydantic_extra_types.color`
    "tests/test_unit/test_plugins/test_pydantic/test_complex_pydantic_fields.py"
    "tests/test_unit/test_plugins/test_pydantic/test_pydantic_dataclasses.py"
    "tests/test_unit/test_plugins/test_pydantic/test_pydantic_snapshots.py"
  ];

  disabledTests = [
    # snapshot expects xmltodict-rs output format; xmltodict differs slightly
    "test_sse_negotiation"
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
