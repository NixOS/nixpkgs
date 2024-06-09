{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  hatchling,
  babel,
  importlib-metadata,
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
  version = "2.27.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jupyterlab_server";
    inherit version;
    hash = "sha256-FcuzSdxF6VTgm6z4G5+byxCBX/Zg+yA07NdBfbOn6ic=";
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
  ] ++ lib.optionals (pythonOlder "3.10") [ importlib-metadata ];

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
  ] ++ optional-dependencies.openapi;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    "-W"
    "ignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # require optional language pack packages for tests
    "tests/test_translation_api.py"
  ];

  pythonImportsCheck = [
    "jupyterlab_server"
    "jupyterlab_server.pytest_plugin"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A set of server components for JupyterLab and JupyterLab like applications";
    homepage = "https://github.com/jupyterlab/jupyterlab_server";
    changelog = "https://github.com/jupyterlab/jupyterlab_server/blob/v${version}/CHANGELOG.md";
    license = licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
  };
}
