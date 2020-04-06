{ lib, stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "avro-python3";
  version = "1.9.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "daab2cea71b942a1eb57d700d4a729e9d6cd93284d4dd4d65a378b9f958aa0d2";
  };

  doCheck = false;        # No such file or directory: './run_tests.py

  meta = with lib; {
    description = "A serialization and RPC framework";
    homepage = https://pypi.python.org/pypi/avro-python3/;
    license = licenses.asl20;

    maintainers = [ maintainers.shlevy maintainers.timma ];
  };
}
