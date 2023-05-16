{ lib, isPy27, buildPythonPackage, fetchPypi, pytestCheckHook, mock }:

let
  pythonEnv = lib.optional isPy27 mock;
in buildPythonPackage rec {
  pname = "json-rpc";
<<<<<<< HEAD
  version = "1.15.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-5kQdVsHc1UJByTfQotzRk73wvcU5tTFlJHE/VUt/hbk=";
=======
  version = "1.14.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-/13xx/2G4dvQJZ8GWZdRzpGnx5DykEFHk6Vlq1ht3FI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeCheckInputs = pythonEnv ++ [ pytestCheckHook ];

  nativeBuildInputs = pythonEnv;

  meta = with lib; {
    description = "JSON-RPC 1/2 transport implementation";
    homepage = "https://github.com/pavlov99/json-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
