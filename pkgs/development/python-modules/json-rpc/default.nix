{ lib, isPy27, buildPythonPackage, fetchPypi, pytestCheckHook, mock }:

let
  pythonEnv = lib.optional isPy27 mock;
in buildPythonPackage rec {
  pname = "json-rpc";
  version = "1.14.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-/13xx/2G4dvQJZ8GWZdRzpGnx5DykEFHk6Vlq1ht3FI=";
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
