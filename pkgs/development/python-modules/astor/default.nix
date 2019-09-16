{ stdenv, buildPythonPackage, fetchPypi, pytest }:

buildPythonPackage rec {
  pname = "astor";
  version = "0.8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0qkq5bf13fqcwablg0nk7rx83izxdizysd42n26j5wbingcfx9ip";
  };

  # disable tests broken with python3.6: https://github.com/berkerpeksag/astor/issues/89
  checkInputs = [ pytest ];
  checkPhase = ''
    py.test -k 'not check_expressions and not check_astunparse and not test_convert_stdlib and not test_codegen_as_submodule and not test_codegen_from_root'
  '';

  meta = with stdenv.lib; {
    description = "Library for reading, writing and rewriting python AST";
    homepage = https://github.com/berkerpeksag/astor;
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
