{
  lib,
  isPy27,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  mock,
}:

let
  pythonEnv = lib.optional isPy27 mock;
in
buildPythonPackage rec {
  pname = "json-rpc";
  version = "1.15.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5kQdVsHc1UJByTfQotzRk73wvcU5tTFlJHE/VUt/hbk=";
  };

  nativeCheckInputs = pythonEnv ++ [ pytestCheckHook ];

  nativeBuildInputs = pythonEnv;

<<<<<<< HEAD
  meta = {
    description = "JSON-RPC 1/2 transport implementation";
    homepage = "https://github.com/pavlov99/json-rpc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ oxzi ];
=======
  meta = with lib; {
    description = "JSON-RPC 1/2 transport implementation";
    homepage = "https://github.com/pavlov99/json-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
