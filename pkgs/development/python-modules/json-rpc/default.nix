{ lib, isPy27, buildPythonPackage, fetchPypi, pytestCheckHook, mock }:

let
  pythonEnv = lib.optional isPy27 mock;
in buildPythonPackage rec {
  pname = "json-rpc";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "12bmblnznk174hqg2irggx4hd3cq1nczbwkpsqqzr13hbg7xpw6y";
  };

  checkInputs = pythonEnv ++ [ pytestCheckHook ];

  nativeBuildInputs = pythonEnv;

  meta = with lib; {
    description = "JSON-RPC 1/2 transport implementation";
    homepage = "https://github.com/pavlov99/json-rpc";
    license = licenses.mit;
    maintainers = with maintainers; [ oxzi ];
  };
}
