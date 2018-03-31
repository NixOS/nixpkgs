{ lib
, buildPythonPackage
, isPy3k
, fetchPypi 
}:

buildPythonPackage rec {
  pname = "ReParser";
  version = "1.4.3";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nniqb69xr0fv7ydlmrr877wyyjb61nlayka7xr08vlxl9caz776";
  };

  meta = {
    homepage = https://github.com/xmikos/reparser;
    description = "Simple regex-based lexer/parser for inline markup";
    license = lib.licenses.mit;
  };
}
