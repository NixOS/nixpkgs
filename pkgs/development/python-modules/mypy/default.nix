{ stdenv, fetchPypi, buildPythonPackage, lxml, typed-ast, psutil, isPy3k
,mypy_extensions }:

buildPythonPackage rec {
  pname = "mypy";
  version = "0.700";

  # Tests not included in pip package.
  doCheck = false;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zxfi5s9hxrz0hbaj4n513az17l44pxl80r62ipjc0bsmbcic2xi";
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
