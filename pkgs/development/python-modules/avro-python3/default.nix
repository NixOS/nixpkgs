{ lib, stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "avro-python3";
  version = "1.9.2.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "ca1e77a3da5ac98e8833588f71fb2e170b38e34787ee0e04920de0e9470b7d32";
  };

  doCheck = false;        # No such file or directory: './run_tests.py

  meta = with lib; {
    description = "A serialization and RPC framework";
    homepage = "https://pypi.python.org/pypi/avro-python3/";
    license = licenses.asl20;

    maintainers = [ maintainers.shlevy maintainers.timma ];
  };
}
