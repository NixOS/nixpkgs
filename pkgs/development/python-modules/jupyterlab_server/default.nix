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
, jupyter_server
, tomli
, openapi-core
, pytest-timeout
, pytest-tornasync
, ruamel-yaml
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "jupyterlab_server";
  version = "2.16.3";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Y1oLF2qQHxk1HAIiGhJOWTF8R29REgBAm32GfospBcM=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    requests
    jsonschema
    json5
    babel
    jupyter_server
    tomli
  ] ++ lib.optional (pythonOlder "3.10") [
    importlib-metadata
  ];

  checkInputs = [
    openapi-core
    pytestCheckHook
    pytest-timeout
    pytest-tornasync
    ruamel-yaml
  ];

  postPatch = ''
    # translation tests try to install additional packages into read only paths
    rm -r tests/translations/
  '';

  # https://github.com/jupyterlab/jupyterlab_server/blob/v2.15.2/pyproject.toml#L61
  doCheck = false;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    # DeprecationWarning: The distutils package is deprecated and slated for removal in Python 3.12.
    # Use setuptools or check PEP 632 for potential alternatives.
    "-W ignore::DeprecationWarning"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A set of server components for JupyterLab and JupyterLab like applications";
    homepage = "https://jupyterlab-server.readthedocs.io/";
    changelog = "https://github.com/jupyterlab/jupyterlab_server/blob/v${version}/CHANGELOG.md";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ costrouc ];
  };
}
