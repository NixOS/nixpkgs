{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  babel,
  jinja2,
  json5,
  jsonschema,
  jupyter-server,
  packaging,
  requests,
  openapi-core,
  pytest-jupyter,
  pytestCheckHook,
  requests-mock,
  ruamel-yaml,
  strict-rfc3339,
}:

buildPythonPackage rec {
  pname = "jupyterlab-server";
  version = "2.28.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyterlab_server";
    inherit version;
    hash = "sha256-NbqoGJixX5NXPi3spQ0RrArkB+u2iCmdOlITJlAzcSw=";
  };

  postPatch = ''
    sed -i "/timeout/d" pyproject.toml
  '';

  build-system = [ hatchling ];

  dependencies = [
    babel
    jinja2
    json5
    jsonschema
    jupyter-server
    packaging
    requests
  ];

  optional-dependencies = {
    openapi = [
      openapi-core
      ruamel-yaml
    ];
  };

  nativeCheckInputs = [
    pytest-jupyter
    pytestCheckHook
    requests-mock
    strict-rfc3339
  ]
  ++ optional-dependencies.openapi;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlags = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # require optional language pack packages for tests
    "tests/test_translation_api.py"
  ];

  pythonImportsCheck = [
    "jupyterlab_server"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Set of server components for JupyterLab and JupyterLab like applications";
    homepage = "https://github.com/jupyterlab/jupyterlab_server";
    changelog = "https://github.com/jupyterlab/jupyterlab_server/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.jupyter ];
  };
}
