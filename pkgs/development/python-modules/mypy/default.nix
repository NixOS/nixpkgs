{ stdenv, fetchPypi, buildPythonPackage, lxml, typed-ast, psutil, isPy3k
,mypy_extensions }:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.650";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ypa7zl14rjd2pnk5zll6yhfz6jfrrdib3dgq3f1f6586pwbbm9q";
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
