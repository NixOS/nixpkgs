{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, hatchling
, babel
, importlib-metadata
, jinja2
, json5
, jsonschema
, jupyter-server
, packaging
, requests
, openapi-core
, pytest-jupyter
, pytestCheckHook
, requests-mock
, ruamel-yaml
, strict-rfc3339
}:

buildPythonPackage rec {
  pname = "jupyterlab-server";
  version = "2.25.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "jupyterlab_server";
    inherit version;
    hash = "sha256-vQ7HqZ687ci8/5Oe+G5Sw3jkTCcH4FP82B0EbOl57mM=";
  };

  postPatch = ''
    sed -i "/timeout/d" pyproject.toml
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    babel
    jinja2
    json5
    jsonschema
    jupyter-server
    packaging
    requests
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  passthru.optional-dependencies = {
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
  ] ++ passthru.optional-dependencies.openapi;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

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
