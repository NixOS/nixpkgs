{ lib
, buildPythonPackage
, fetchPypi
, hatchling
, jsonschema
, pythonOlder
, requests
, pytestCheckHook
, json5
, babel
, jupyter-server
, tomli
, openapi-core
, pytest-jupyter
, requests-mock
, ruamel-yaml
, strict-rfc3339
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "jupyterlab_server";
  version = "2.25.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-d8Lx8oLWEPleSW4g1b8dKncGgm37exjzN4rihw0nL7c=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    requests
    jsonschema
    json5
    babel
    jupyter-server
    tomli
  ] ++ lib.optionals (pythonOlder "3.10") [
    importlib-metadata
  ];

  nativeCheckInputs = [
    openapi-core
    pytestCheckHook
    pytest-jupyter
    requests-mock
    ruamel-yaml
    strict-rfc3339
  ];

  postPatch = ''
    sed -i "/timeout/d" pyproject.toml
  '';

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    # DeprecationWarning: The distutils package is deprecated and slated for removal in Python 3.12.
    # Use setuptools or check PEP 632 for potential alternatives.
    "-W ignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    "tests/test_settings_api.py"
    "tests/test_themes_api.py"
    "tests/test_translation_api.py"
    "tests/test_workspaces_api.py"
  ];

  disabledTests = [
    "test_get_listing"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A set of server components for JupyterLab and JupyterLab like applications";
    homepage = "https://jupyterlab-server.readthedocs.io/";
    changelog = "https://github.com/jupyterlab/jupyterlab_server/blob/v${version}/CHANGELOG.md";
    license = licenses.bsdOriginal;
    maintainers = lib.teams.jupyter.members;
  };
}
