{ lib, buildPythonPackage, fetchPypi, isPy27, pytestCheckHook, fetchpatch }:

buildPythonPackage rec {
  pname = "astor";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ppscdzzvxpznclkmhhj53iz314x3pfv4yc7c6gwxqgljgdgyvka";
  };

  # disable tests broken with python3.6: https://github.com/berkerpeksag/astor/issues/89
  checkInputs = [ pytestCheckHook ];
  disabledTests = [
    "check_expressions"
    "check_astunparse"
    "convert_stdlib"
    "codegen_as_submodule"
    "positional_only_arguments"
    "codegen_from_root"
  ];

  meta = with lib; {
    description = "Library for reading, writing and rewriting python AST";
    homepage = "https://github.com/berkerpeksag/astor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
