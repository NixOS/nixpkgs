{ stdenv, fetchPypi, buildPythonPackage, typed-ast, psutil, isPy3k
,mypy_extensions }:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.701";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "05479r3gbq17r22hyhxjg49smx5q864pgx8ayy23rsdj4w6z2r2p";
  };

  disabled = !isPy3k;

  propagatedBuildInputs = [ typed-ast psutil mypy_extensions ];

  meta = with stdenv.lib; {
    description = "Optional static typing for Python";
    homepage    = "http://www.mypy-lang.org";
    license     = licenses.mit;
    maintainers = with maintainers; [ martingms lnl7 ];
  };
}
