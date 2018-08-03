{ stdenv, buildPythonPackage, fetchPypi, isPy3k, lib}:

buildPythonPackage rec {
  pname = "ReParser";
  version = "1.4.3";
  
  disabled = ! isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e69caf58a29d6e04723f6a7a456d304b7acfcf413957dafcd90ee49eccc2d15a";
  };

  # Not tests included in PyPi package;
  doCheck = false;

  meta = {
    description = "Simple regex-based lexer/parser for inline markup";
    license = stdenv.lib.licenses.mit;
    homepage = https://github.com/xmikos/reparser;
    maintainers = with lib.maintainers; [ aswan89 ];
  };
}
