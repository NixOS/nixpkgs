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
<<<<<<< HEAD
, pytest-jupyter
, requests-mock
, ruamel-yaml
, strict-rfc3339
=======
, pytest-timeout
, pytest-tornasync
, ruamel-yaml
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "jupyterlab_server";
<<<<<<< HEAD
  version = "2.24.0";
=======
  version = "2.19.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
<<<<<<< HEAD
    hash = "sha256-Tm+Z4KVXm7vDLkScTbsDlWHU8aeCfVczJz7VZzjyHwc=";
=======
    hash = "sha256-muwhohg7vt2fkahmKDVUSVdfGGLYiyitX5BQGdMebCE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    pytest-jupyter
    requests-mock
    ruamel-yaml
    strict-rfc3339
  ];

  postPatch = ''
    sed -i "/timeout/d" pyproject.toml
  '';

=======
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

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    # DeprecationWarning: The distutils package is deprecated and slated for removal in Python 3.12.
    # Use setuptools or check PEP 632 for potential alternatives.
    "-W ignore::DeprecationWarning"
  ];

<<<<<<< HEAD
  disabledTestPaths = [
    "tests/test_settings_api.py"
    "tests/test_themes_api.py"
    "tests/test_translation_api.py"
    "tests/test_workspaces_api.py"
  ];

  disabledTests = [
    "test_get_listing"
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "A set of server components for JupyterLab and JupyterLab like applications";
    homepage = "https://jupyterlab-server.readthedocs.io/";
    changelog = "https://github.com/jupyterlab/jupyterlab_server/blob/v${version}/CHANGELOG.md";
    license = licenses.bsdOriginal;
<<<<<<< HEAD
    maintainers = lib.teams.jupyter.members;
=======
    maintainers = with maintainers; [ costrouc ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
