{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "ReParser";
  version = "1.4.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0nniqb69xr0fv7ydlmrr877wyyjb61nlayka7xr08vlxl9caz776";
  };

  name = "${pname}-${version}";

  meta = {
    homepage = https://github.com/xmikos/reparser;
    description = "Simple regex-based lexer/parser for inline markup";
    license = lib.licenses.mit;
  };
}
