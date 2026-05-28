{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  click,
  dill,
  fica,
  ipylab,
  ipython,
  ipywidgets,
  jinja2,
  jupytext,
  nbconvert,
  nbformat,
  pandas,
  python-on-whales,
  pyyaml,
  requests,
  wrapt,
  ipykernel,
  jupyter-client,
  pypdf,
  google-api-python-client,
  google-auth-oauthlib,
  gspread,
  six,
  rpy2,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
  pytest-html,
  matplotlib,
  tqdm,
  R,
  rPackages,
}:

buildPythonPackage (finalAttrs: {
  pname = "otter-grader";
  version = "6.1.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ucbds-infra";
    repo = "otter-grader";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bqBwDbxnvRm7W9r87YK9vwi3sSyoyqbdnqVs5HxOzsg=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    click
    dill
    fica
    ipylab
    ipython
    ipywidgets
    jinja2
    jupytext
    nbconvert
    nbformat
    pandas
    python-on-whales
    pyyaml
    requests
    wrapt
  ];

  optional-dependencies = {
    grading = [
      ipykernel
      jupyter-client
      pypdf
    ];
    plugins = [
      google-api-python-client
      google-auth-oauthlib
      gspread
      six
    ];
    r = [
      rpy2
    ];
  };

  pythonRelaxDeps = [
    "fica"
  ];

  pythonImportsCheck = [
    "otter"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
    pytest-html
    matplotlib
    tqdm
    R
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  checkInputs = [
    rPackages.knitr
    rPackages.ottr
  ];

  disabledTests = [
    # requires Docker
    "test_timeout_some_notebooks_finish"
    "test_timeout_no_notebooks_finish"
    "test_network"
    "test_notebooks_with_pdfs"
    "test_config_overrides_integration"
    "test_queue"
    # testthat 3.x assertion message format differs from the expected results in
    # this R Markdown test, causing a partial credit output mismatch
    "test_rmd"
  ]
  ++ lib.optionals stdenv.isDarwin [
    # socket.bind() fails under macOS sandbox
    "test_otter_example"
    "test_jupyterlite"
    "test_require_no_pdf_ack"
    "test_require_no_pdf_ack_with_message"
    "test_otter_check_script"
    "test_otter_check_notebook"
    "test_kernel_override"
    "test_log_execution"
    "test_results_load_failure_handling"
    "test_notebook"
    "test_pdf_generation_failure"
    "test_use_submission_pdf"
    "test_force_public_test_summary"
    "test_script"
    "test_assignment_name"
    "test_token_sanitization"
    "test_pdf_via_html"
  ];

  meta = {
    description = "Python and R autograder";
    homepage = "https://github.com/ucbds-infra/otter-grader";
    changelog = "https://github.com/ucbds-infra/otter-grader/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hhr2020 ];
  };
})
