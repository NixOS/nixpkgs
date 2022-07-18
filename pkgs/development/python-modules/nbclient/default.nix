{ async_generator
, buildPythonPackage
, fetchFromGitHub
, ipykernel
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

let nbclient = buildPythonPackage rec {
  pname = "nbclient";
  version = "0.6.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jupyter";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-ofyJNJeNkXbZ9qHLTuzJ13PgEXU9lDQ9NkT4nG/R8Ic=";
  };

  propagatedBuildInputs = [ async_generator traitlets nbformat nest-asyncio jupyter-client ];

  # circular dependencies if enabled by default
  doCheck = false;

  checkInputs = [
    ipykernel
    ipywidgets
    nbconvert
    pytest-asyncio
    pytestCheckHook
    xmltodict
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.tests = {
    check = nbclient.overridePythonAttrs (_: { doCheck = true; });
  };

  meta = with lib; {
    homepage = "https://github.com/jupyter/nbclient";
    description = "A client library for executing notebooks";
    license = licenses.bsd3;
    maintainers = [ maintainers.erictapen ];
  };
};
in nbclient
