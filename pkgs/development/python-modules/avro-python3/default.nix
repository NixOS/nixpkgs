{ lib, stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "avro-python3";
  version = "1.8.2";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "f82cf0d66189600b1e6b442f650ad5aca6c189576723dcbf6f9ce096eab81bd6";
  };

  doCheck = false;        # No such file or directory: './run_tests.py

  meta = with lib; {
    description = "A serialization and RPC framework";
    homepage = https://pypi.python.org/pypi/avro-python3/;
    license = licenses.asl20;

    maintainers = [ maintainers.shlevy maintainers.timma ];
  };
}
