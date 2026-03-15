{
  lib,
  buildPythonPackage,
  cryptography,
  defusedxml,
  fetchFromGitHub,
  gql,
  graphql-core,
  marshmallow,
  pydantic-extra-types,
  pydantic,
  pytest-cov-stub,
  pytest-datafiles,
  pytest-vcr,
  pytestCheckHook,
  python-box,
  python-dateutil,
  requests-pkcs12,
  requests-toolbelt,
  requests,
  responses,
  restfly,
  semver,
  setuptools,
  typing-extensions,
}:
let
  marshmallow' = marshmallow.overrideAttrs (super: {
    version = "3.26.2";
    src = fetchFromGitHub {
      owner = "marshmallow-code";
      repo = "marshmallow";
      tag = "3.26.2";
      hash = "sha256-ioe+aZHOW8r3wF3UknbTjAP0dEggd/NL9PTkPVQ46zM=";
    };
    disabledTests = super.disabledTests ++ [
      "test_from_timestamp_with_overflow_value"
    ];
  });
in
buildPythonPackage (finalAttrs: {
  pname = "pytenable";
  version = "1.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tenable";
    repo = "pyTenable";
    tag = finalAttrs.version;
    hash = "sha256-ml5364D3qvd6VNhF2JyGoCzxbdO0DBkaBMoD38O5x8o=";
  };

  pythonRelaxDeps = [
    "cryptography"
    "defusedxml"
  ];

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    defusedxml
    gql
    graphql-core
    marshmallow'
    pydantic
    pydantic-extra-types
    python-box
    python-dateutil
    requests
    requests-toolbelt
    restfly
    semver
    typing-extensions
  ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytest-datafiles
    pytest-vcr
    pytestCheckHook
    requests-pkcs12
    responses
  ];

  pytestFlags = [
    "-Wignore::pytest.PytestRemovedIn9Warning"
  ];

  disabledTestPaths = [
    # Disable tests that requires network access
    "tests/io/"
  ];

  disabledTests = [
    # Disable tests that requires a Docker container
    "test_uploads_docker_push_name_typeerror"
    "test_uploads_docker_push_tag_typeerror"
    "test_uploads_docker_push_cs_name_typeerror"
    "test_uploads_docker_push_cs_tag_typeerror"
    # Test requires network access
    "test_assets_list_vcr"
    "test_events_list_vcr"
    # https://github.com/tenable/pyTenable/issues/953
    "test_construct_query_str"
    "test_construct_query_stored_file"
    "test_iterator_empty_page"
    "test_iterator_max_page_term"
    "test_iterator_pagination"
    "test_iterator_total_term"
  ];

  pythonImportsCheck = [ "tenable" ];

  meta = {
    description = "Python library for the Tenable.io and TenableSC API";
    homepage = "https://github.com/tenable/pyTenable";
    changelog = "https://github.com/tenable/pyTenable/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
