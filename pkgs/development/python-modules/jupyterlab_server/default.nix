{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, hatchling
, jsonschema
, pythonOlder
, requests
, pytestCheckHook
, pyjson5
, babel
, jupyter_server
, openapi-core
, pytest-timeout
, pytest-tornasync
, ruamel-yaml
, strict-rfc3339
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

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov jupyterlab_server --cov-report term-missing --cov-report term:skip-covered" ""

    # translation tests try to install additional packages into read only paths
    rm -r tests/translations/
  '';

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [ requests jsonschema pyjson5 babel jupyter_server ];

  checkInputs = [
    openapi-core
    pytestCheckHook
    pytest-timeout
    pytest-tornasync
    ruamel-yaml
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    # DeprecationWarning: The distutils package is deprecated and slated for removal in Python 3.12. Use setuptools or check PEP 632 for potential alternatives
    "-W ignore::DeprecationWarning"
  ];

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "JupyterLab Server";
    homepage = "https://jupyter.org";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
