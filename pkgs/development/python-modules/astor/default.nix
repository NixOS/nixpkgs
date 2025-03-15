{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "astor";
  version = "0.8.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ppscdzzvxpznclkmhhj53iz314x3pfv4yc7c6gwxqgljgdgyvka";
  };

  # disable tests broken with python3.6: https://github.com/berkerpeksag/astor/issues/89
  nativeCheckInputs = [ pytestCheckHook ];

  disabledTests = [
    # https://github.com/berkerpeksag/astor/issues/196
    "test_convert_stdlib"
    # https://github.com/berkerpeksag/astor/issues/212
    "test_huge_int"
    "CodegenTestCase::test_complex"
    "CodegenTestCase::test_deprecated_constant_nodes"
    "CodegenTestCase::test_deprecated_name_constants"
    "CodegenTestCase::test_fstring_debugging"
    "CodegenTestCase::test_fstring_escaped_braces"
    "CodegenTestCase::test_fstring_trailing_newline"
    "CodegenTestCase::test_fstrings"
    "CodegenTestCase::test_inf"
    "CodegenTestCase::test_nan"
  ];

  meta = with lib; {
    description = "Library for reading, writing and rewriting python AST";
    homepage = "https://github.com/berkerpeksag/astor";
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
