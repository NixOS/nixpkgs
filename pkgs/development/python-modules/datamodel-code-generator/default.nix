{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,

  # build-system
  hatch-vcs,
  hatchling,

  # dependencies
  argcomplete,
  genson,
  inflect,
  jinja2,
  packaging,
  pydantic,
  pyyaml,

  # optional-dependencies
  # black:
  black,
  # debug:
  pysnooper,
  # graphql:
  graphql-core,
  # http:
  httpx,
  # isort
  isort,
  # protobuf:
  grpcio-tools,
  # ruff:
  ruff,
  # validation:
  openapi-spec-validator,
  prance,
  # watch:
  watchfiles,

  # tests
  email-validator,
  hypothesis,
  hypothesis-jsonschema,
  inline-snapshot,
  jsonschema,
  msgspec,
  pytest-mock,
  pytest-timeout,
  pytest-xdist,
  time-machine,
  lxml,
  trustme,
  coverage,
  covdefaults,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "datamodel-code-generator";
  version = "0.83.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "koxudaxi";
    repo = "datamodel-code-generator";
    tag = finalAttrs.version;
    hash = "sha256-70jeTU5IQG0lyT34+wKfQfF3kjglntRQxXXiklZntAk=";
  };

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    argcomplete
    black
    genson
    inflect
    isort
    jinja2
    packaging
    pydantic
    pyyaml
  ];

  optional-dependencies = lib.fix (self: {
    black = [ black ];
    debug = [ pysnooper ];
    graphql = [ graphql-core ];
    http = [ httpx ];
    isort = [ isort ];
    protobuf = [ grpcio-tools ];
    ruff = [ ruff ];
    validation = [
      openapi-spec-validator
      prance
    ];
    watch = [ watchfiles ];
  });

  nativeCheckInputs = [
    email-validator
    hypothesis
    hypothesis-jsonschema
    inline-snapshot
    jsonschema
    msgspec
    pytest-mock
    pytest-timeout
    pytest-xdist
    time-machine
    lxml
    trustme
    # The following is needed to run some tests that
    # leverage coverage to check code execution.
    coverage
    covdefaults
    pytestCheckHook
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  disabledTests = [
    # remote testing, name resolution failure.
    "test_openapi_parser_parse_remote_ref"

    # ruff formatting changed, causing errors such as
    #   Failed: Output mismatch
    #   AssertionError: Content mismatch for ...
    "test_no_use_type_checking_imports"
    "test_ruff_batch_formatting_directory"
    "test_ruff_check_and_format_combined"
    "test_ruff_check_only"
    "test_type_checking_imports_default_to_runtime_imports_for_modular_pydantic_ruff"

    # Double-check:

    # Output mismatch
    # "test_additional_pattern_intersections"
    # "test_undeclared_required"
  ];

  disabledTestPaths = [
    # This tests a script for the CI/CD pipeline, not part of the package itself.
    "tests/test_resolve_release_draft_pr_script.py"
    "tests/test_build_release_benchmark_docs_script.py"
  ];

  disabledTestMarks = [
    # Performance & benchmark tests
    "benchmark"
    "perf"
  ];

  patches = [
    ./01-fix-tests.patch
  ];

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  # The tests are run with the builtin formatter, which is not the default, as it is done in the upstream.
  # https://github.com/datamodel-code-generator/datamodel-code-generator/blob/34f144ff3569ef7525c1718a5d818841ed2cc43a/tox.ini#L135
  preCheck = ''
    export DATAMODEL_CODE_GENERATOR_TEST_DEFAULT_FORMATTER=builtin
    export DATAMODEL_CODE_GENERATOR_EXPECTED_HTTP_BACKEND=httpx
  '';

  postCheck = ''
    unset DATAMODEL_CODE_GENERATOR_TEST_DEFAULT_FORMATTER
    unset DATAMODEL_CODE_GENERATOR_EXPECTED_HTTP_BACKEND
  '';

  pythonImportsCheck = [ "datamodel_code_generator" ];

  meta = {
    description = "Pydantic model and dataclasses.dataclass generator for easy conversion of JSON, OpenAPI, JSON Schema, and YAML data sources";
    homepage = "https://github.com/koxudaxi/datamodel-code-generator";
    changelog = "https://github.com/koxudaxi/datamodel-code-generator/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "datamodel-codegen";
  };
})
