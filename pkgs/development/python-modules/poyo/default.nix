{ stdenv
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  version = "0.4.0";
  pname = "poyo";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1f48ffl0j1f2lmgabajps7v8w90ppxbp5168gh8kh27bjd8xk5ca";
  };

  meta = with stdenv.lib; {
    homepage = https://github.com/hackebrot/poyo;
    description = "A lightweight YAML Parser for Python";
    license = licenses.mit;
  };

}
