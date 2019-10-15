{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "cement";
  version = "3.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "10a8459dc9fc31d6c038ede24a9081c5c3bd5fcd75b071e01baf281f81c9eace";
  };

  # Disable test tests since they depend on a memcached server running on
  # 127.0.0.1:11211.
  doCheck = false;

  disabled = !isPy3k;

  meta = with stdenv.lib; {
    homepage = https://builtoncement.com/;
    description = "A CLI Application Framework for Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.bsd3;
  };
}
