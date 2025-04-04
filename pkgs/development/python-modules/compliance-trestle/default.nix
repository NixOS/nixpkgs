{
  attrs,
  buildPythonPackage,
  cmarkgfm,
  cryptography,
  defusedxml,
  datamodel-code-generator,
  email-validator,
  fetchFromGitHub,
  furl,
  ilcli,
  importlib-resources,
  jinja2,
  lib,
  mypy,
  openpyxl,
  orjson,
  paramiko,
  pytestCheckHook,
  pydantic,
  python-dotenv,
  python-frontmatter,
  requests,
  ruamel-yaml,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "compliance-trestle";
  version = "3.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oscal-compass";
    repo = "compliance-trestle";
    tag = "v${version}";
    hash = "sha256-MEPleUM5gSCJjVaVbNtNzRl+Vvvk97h6Q/mOWIxFd2Q=";
    fetchSubmodules = true;
  };

  pythonRelaxDeps = true;

  postPatch = ''
    substituteInPlace tests/trestle/misc/mypy_test.py \
      --replace-fail "trestle'," "${placeholder "out"}/bin/trestle'," \
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    attrs
    cmarkgfm
    cryptography
    defusedxml
    datamodel-code-generator
    email-validator
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
  ];

  nativeCheckInputs = [
    pytestCheckHook
    mypy
  ];

  disabledTests = [
    # Requires network access
    "test_import_from_url"
    "test_import_from_nist"
    "test_remote_profile_relative_cat"

    # AssertionError
    "test_profile_generate_assemble_rev_5"
    "test_ssp_assemble_fedramp_profile"
    "test_ssp_generate_aggregates_no_cds"
    "test_ssp_generate_aggregates_no_param_value_orig"
  ];

  disabledTestPaths = [
    # Requires network access
    "tests/trestle/core/remote"
  ];

  pythonImportsCheck = [ "trestle" ];

  meta = {
    description = "An opinionated tooling platform for managing compliance as code, using continuous integration and NIST's OSCAL standard";
    homepage = "https://github.com/oscal-compass/compliance-trestle";
    changelog = "https://github.com/oscal-compass/compliance-trestle/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ tochiaha ];
    mainProgram = "trestle";
  };
}
