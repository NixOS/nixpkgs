{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonAtLeast,

  # build-system
  hatchling,

  # dependencies
  attrs,
  cmarkgfm,
  cryptography,
  defusedxml,
  furl,
  ilcli,
  importlib-resources,
  jinja2,
  openpyxl,
  orjson,
  paramiko,
  pydantic,
  python-dotenv,
  python-frontmatter,
  requests,
  ruamel-yaml,
  rfc8785,
  securesystemslib,

  # tests
  datamodel-code-generator,
  pytestCheckHook,
  mypy,
}:
buildPythonPackage (finalAttrs: {
  pname = "compliance-trestle";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oscal-compass";
    repo = "compliance-trestle";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-8ObzK0P1syPw7L6m0LfCs507jruazxRNNwob5CzS6Zw=";
  };

  postPatch = ''
    substituteInPlace tests/trestle/misc/mypy_test.py \
      --replace-fail "trestle'," "${placeholder "out"}/bin/trestle',"
  '';

  build-system = [
    hatchling
  ];

  dependencies = [
    attrs
    cmarkgfm
    cryptography
    defusedxml
    furl
    ilcli
    importlib-resources
    jinja2
    openpyxl
    orjson
    paramiko
    pydantic
    python-dotenv
    python-frontmatter
    requests
    ruamel-yaml
    securesystemslib
    rfc8785
  ]
  ++ securesystemslib.optional-dependencies.crypto
  ++ pydantic.optional-dependencies.email;

  nativeCheckInputs = [
    datamodel-code-generator
    mypy
    pytestCheckHook
  ];

  disabledTests = [
    # Requires network access
    "test_import_from_url"
    "test_import_from_nist"
    "test_remote_profile_relative_cat"
    "test_ssp_generate_missing_profile_param_value_origin_regression"

    # AssertionError
    "test_profile_generate_assemble_rev_5"
    "test_ssp_assemble_fedramp_profile"
    "test_ssp_generate_aggregates_no_cds"
    "test_ssp_generate_aggregates_no_param_value_orig"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # AssertionError: assert 1 == 0
    # AttributeError: 'AliasTracker' object has no attribute 'aliases'
    "test_arguments"
    "test_get_list_cli"
    "test_load_custom_config"
    "test_load_default_config"
    "test_split_catalog_star"
    "test_split_comp_def"
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/trestle/core/remote"
  ]
  ++ lib.optionals (pythonAtLeast "3.14") [
    # pydantic.v1.errors.ConfigError: unable to infer type for attribute "poam"
    "tests/trestle/core/models/interfaces_test.py"
    "tests/trestle/tasks/ocp4_cis_profile_to_oscal_catalog_test.py"
  ];

  pythonImportsCheck = [ "trestle" ];

  meta = {
    description = "Opinionated tooling platform for managing compliance as code, using continuous integration and NIST's OSCAL standard";
    homepage = "https://github.com/oscal-compass/compliance-trestle";
    changelog = "https://github.com/oscal-compass/compliance-trestle/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "trestle";
  };
})
