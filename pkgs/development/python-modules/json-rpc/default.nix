{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "json-rpc";
  version = "1.15.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5kQdVsHc1UJByTfQotzRk73wvcU5tTFlJHE/VUt/hbk=";
  };

  nativeCheckInputs = [ pytestCheckHook ];

  meta = {
    description = "JSON-RPC 1/2 transport implementation";
    homepage = "https://github.com/pavlov99/json-rpc";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
