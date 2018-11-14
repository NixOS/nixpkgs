{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "cement";
  version = "3.0.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e50e1033d61d18b36787a60d52cad0d3fe20780e7e2f78f0204bde32000645f9";
  };

  # Disable test tests since they depend on a memcached server running on
  # 127.0.0.1:11211.
  doCheck = false;

  disabled = !isPy3k;

  meta = with stdenv.lib; {
    homepage = http://builtoncement.com/;
    description = "A CLI Application Framework for Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.bsd3;
  };
}
