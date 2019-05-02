{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "cement";
  version = "3.0.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8c692493c9d97b07e4a2c0770223fa5ee12a3110cfcb246d7d26fffe22edd22e";
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
