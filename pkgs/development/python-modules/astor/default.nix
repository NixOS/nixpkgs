{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "astor";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "95c30d87a6c2cf89aa628b87398466840f0ad8652f88eb173125a6df8533fb8d";
  };

  checkInputs = [ pytest ];

  # disable tests broken with python3.6: https://github.com/berkerpeksag/astor/issues/89
  checkPhase = pytest.runTests {
    disabledTests = [
      "check_expressions"
      "check_astunparse"
      "test_convert_stdlib"
      "test_codegen_as_submodule"
      "test_codegen_from_root"
    ];
  };

  meta = with stdenv.lib; {
    description = "Library for reading, writing and rewriting python AST";
    homepage = https://github.com/berkerpeksag/astor;
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
