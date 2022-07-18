{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, jsonschema
, pythonOlder
, requests
, pytestCheckHook
, pyjson5
, babel
, jupyter_server
, openapi-core
, pytest-tornasync
, ruamel-yaml
, strict-rfc3339
}:

buildPythonPackage rec {
  pname = "jupyterlab_server";
  version = "2.12.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AOD0tMOZ9Vk4Mj6hDPktkVKI/hJ1PjXRBp9soItyq78=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--cov jupyterlab_server --cov-report term-missing --cov-report term:skip-covered" ""

    # translation tests try to install additional packages into read only paths
    rm -r tests/translations/
  '';

  propagatedBuildInputs = [ requests jsonschema pyjson5 babel jupyter_server ];

  checkInputs = [
    openapi-core
    pytestCheckHook
    pytest-tornasync
    ruamel-yaml
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  __darwinAllowLocalNetworking = true;

  meta = with lib; {
    description = "JupyterLab Server";
    homepage = "https://jupyter.org";
    license = licenses.bsdOriginal;
    maintainers = [ maintainers.costrouc ];
  };
}
