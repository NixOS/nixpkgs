{ stdenv, fetchPypi, buildPythonPackage, lxml, typed-ast, psutil, isPy3k
,mypy_extensions }:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.670";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e80fd6af34614a0e898a57f14296d0dacb584648f0339c2e000ddbf0f4cc2f8d";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ lxml typed-ast psutil mypy_extensions ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
