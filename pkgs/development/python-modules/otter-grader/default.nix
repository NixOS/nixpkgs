{
  lib,
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

  meta = {
    description = "Python and R autograder";
    homepage = "https://github.com/ucbds-infra/otter-grader";
    changelog = "https://github.com/ucbds-infra/otter-grader/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ hhr2020 ];
  };
})
