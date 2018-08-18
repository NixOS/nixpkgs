{ stdenv, buildPythonPackage, fetchPypi }:

buildPythonPackage rec {
  pname = "cement";
  version = "2.10.12";

  src = fetchPypi {
    inherit pname version;
    sha256 = "58efb4eacd9ec977ce797a364a13851de6e42392bbde5287d44294f06c5a2f70";
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
