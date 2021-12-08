{ lib, buildPythonPackage, fetchFromGitHub, pytestCheckHook }:

buildPythonPackage rec {
  pname = "astor";
  version = "0.8.1";

  src = fetchFromGitHub {
     owner = "berkerpeksag";
     repo = "astor";
     rev = "0.8.1";
     sha256 = "1svh9wjfvx1j2ljd8agnbbzm71572nf7z2rvf4j3byxlipgv9kd3";
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
