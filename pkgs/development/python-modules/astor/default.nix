{ lib, buildPythonPackage, fetchPypi, isPy27, pytest, fetchpatch }:

buildPythonPackage rec {
  pname = "astor";
  version = "0.8.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0ppscdzzvxpznclkmhhj53iz314x3pfv4yc7c6gwxqgljgdgyvka";
  };

  # disable tests broken with python3.6: https://github.com/berkerpeksag/astor/issues/89
  checkInputs = [ pytest ];
  checkPhase = ''
    py.test -k 'not check_expressions \
                and not check_astunparse \
                and not test_convert_stdlib \
                and not test_codegen_as_submodule \
                and not test_positional_only_arguments \
                and not test_codegen_from_root'
  '';

  meta = with lib; {
    description = "Library for reading, writing and rewriting python AST";
    homepage = https://github.com/berkerpeksag/astor;
    license = licenses.bsd3;
    maintainers = with maintainers; [ nixy ];
  };
}
