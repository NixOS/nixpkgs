{ async_generator
, buildPythonPackage
, doCheck ? true
, fetchFromGitHub
, ipywidgets
, jupyter-client
, lib
, nbconvert
, nbformat
, nest-asyncio
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, traitlets
, xmltodict
}:

buildPythonPackage rec {
  pname = "nbclient";
  version = "0.6.2";
  # As of version 0.6.2, there is both a setup.py and pyproject.toml. However,
  # the pyproject.toml does not appear to be the main entry point.
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-5mBlc/DhjBiBAytwOQvB5WO2AHbIJQSpyww7ar8ONbo=";
  };

  propagatedBuildInputs = [
    async_generator
    jupyter-client
    nbformat
    nest-asyncio
    traitlets
  ];

  inherit doCheck;

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  checkInputs = [
    ipywidgets
    nbconvert
    pytest-asyncio
    pytestCheckHook
    xmltodict
  ];

  # For some reason this still doesn't fix https://github.com/NixOS/nixpkgs/issues/171493.
  pythonImportsCheck = [ "nbclient" ];

  meta = with lib; {
    homepage = "https://github.com/jupyter/nbclient";
    description = "A client library for executing notebooks";
    license = licenses.bsd3;
    maintainers = with maintainers; [ erictapen ];
  };
}
