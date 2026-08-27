{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  requests,
  websockets,
}:

buildPythonPackage rec {
  pname = "mopidyapi";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-n1BJGHFZvuGSSumEXWIjH/CiHs5w/8skhz7yfR7Jplw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"flit"' '"flit_core"' \
      --replace-fail "flit.buildapi" "flit_core.buildapi"
  '';

  build-system = [ flit-core ];

  dependencies = [
    requests
    websockets
  ];

  pythonImportsCheck = [ "mopidyapi" ];

  # PyPi does not include tests
  doCheck = false;

  meta = {
    description = "Module for interacting with Mopidy via its JSON RPC API";
    homepage = "https://github.com/AsbjornOlling/mopidyapi";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ fab ];
  };
}
