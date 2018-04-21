{ stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "avro3k";
  version = "1.7.7-SNAPSHOT";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "15ahl0irwwj558s964abdxg4vp6iwlabri7klsm2am6q5r0ngsky";
  };

  doCheck = false;        # No such file or directory: './run_tests.py

  meta = with stdenv.lib; {
    description = "A serialization and RPC framework";
    homepage = https://pypi.python.org/pypi/avro3k/;
  };
}
