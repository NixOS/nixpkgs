{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cement";
  version = "2.10.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d50c5980bf3e2456e515178ba097d16e36be0fbcab7811a60589d22f45b64f55";
  };

  # Disable test tests since they depend on a memcached server running on
  # 127.0.0.1:11211.
  doCheck = false;

  meta = with stdenv.lib; {
    homepage = http://builtoncement.com/;
    description = "A CLI Application Framework for Python.";
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.bsd3;
  };
}
