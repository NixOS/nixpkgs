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
, openapi-core
, pytest-timeout
, pytest-tornasync
, ruamel-yaml
, importlib-metadata
}:

buildPythonPackage rec {
  pname = "jupyterlab_server";
  version = "2.15.1";
  format = "pyproject";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MFMTlw4THFkM93u2uMp+mFkbwwQRHo0QO8kdIS6UeW8=";
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
  ] ++ lib.optional (pythonOlder "3.10") importlib-metadata;

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
    homepage = "https://jupyter.org";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
