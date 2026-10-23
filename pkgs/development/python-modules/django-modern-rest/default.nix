{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  pythonOlder,
  runCommand,

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
  pyjwt,
  openapi-spec-validator,
  polyfactory,
  pyyaml,
  attrs,

  # tests
  dirty-equals,
  dj-database-url,
  django-allauth,
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

buildPythonPackage (finalAttrs: {
  pname = "django-modern-rest";
  version = "0.16.0";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "wemake-services";
    repo = "django-modern-rest";
    tag = finalAttrs.version;
    hash = "sha256-MmN1eX6to6hqUgafJHPRC0gUXdDJBYcWDogSsA/3WJ4=";
  };

  postPatch = ''
    # xmltodict-rs is not packaged in nixpkgs; xmltodict is API-compatible
    # for the parse/unparse calls used here.
    substituteInPlace \
      tests/infra/xml_format.py \
      django_test_app/server/apps/negotiations/views.py \
      --replace-fail "import xmltodict_rs as xmltodict" "import xmltodict"

    # pydantic-extra-types 2.11.0 does not export Color at the package root.
    substituteInPlace \
      tests/test_unit/test_plugins/test_pydantic/test_complex_pydantic_fields.py \
      tests/test_unit/test_plugins/test_pydantic/test_pydantic_dataclasses.py \
      tests/test_unit/test_plugins/test_pydantic/test_pydantic_snapshots.py \
      --replace-fail "from pydantic_extra_types import Color" "from pydantic_extra_types.color import Color"
  '';

  build-system = [
    hatchling
    hatch-fancy-pypi-readme
  ];

  dependencies = [
    django
    typing-extensions
  ];

  # The wheel only includes the project's own license.
  postInstall = ''
    install -Dm644 licenses/*.txt -t "$out/share/doc/${finalAttrs.pname}/licenses"
  '';

  optional-dependencies = {
    msgspec = [ msgspec ];
    # The timezone extra only adds tzdata on Windows.
    pydantic = [
      pydantic
      pydantic-extra-types
    ]
    ++ pydantic.optional-dependencies.email;
    jwt = [ pyjwt ] ++ pyjwt.optional-dependencies.crypto;
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
    dj-database-url
    django-allauth
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
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  enabledTestPaths = [ "tests" ];

  pytestFlags = [
    # Coverage and tracecov are only needed for upstream's CI.
    "--override-ini"
    "addopts="
  ];

  disabledTestPaths = [
    # Schema fuzzing requires schemathesis, which is not packaged in nixpkgs.
    "tests/test_integration/test_openapi/test_schema.py"
    # These integration tests need Docker to start Redis containers.
    "tests/test_integration/test_throttling"
  ];

  disabledTests = [
    # These XML rendering checks expect xmltodict-rs whitespace.
    "test_sse_negotiation"
    # error message for invalid XML differs between xmltodict (expat) and
    # xmltodict-rs ("unclosed token" vs "unclosed element(s) found")
    "test_negotiation_invalid_xml"
  ];

  pythonImportsCheck = [ "dmr" ];

  passthru.tests.smoke =
    runCommand "django-modern-rest-smoke-test"
      {
        nativeBuildInputs = [
          (python.withPackages (
            _: [ finalAttrs.finalPackage ] ++ finalAttrs.passthru.optional-dependencies.msgspec
          ))
        ];
      }
      ''
        python ${./smoke-test.py}
        touch "$out"
      '';

  meta = {
    changelog = "https://github.com/wemake-services/django-modern-rest/releases/tag/${finalAttrs.version}";
    description = "Modern REST framework for Django with types and async support";
    homepage = "https://github.com/wemake-services/django-modern-rest";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      obfuscatedCode # Bundled, minified OpenAPI UI assets.
    ];
    license =
      with lib.licenses;
      AND [
        mit
        asl20
      ];
    maintainers = with lib.maintainers; [ sesav ];
  };
})
