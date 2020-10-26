{ lib, stdenv, buildPythonPackage, fetchPypi, isPy3k }:

buildPythonPackage rec {
  pname = "avro-python3";
  version = "1.10.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "a455c215540b1fceb1823e2a918e94959b54cb363307c97869aa46b5b55bde05";
  };

  doCheck = false;        # No such file or directory: './run_tests.py

  meta = with lib; {
    broken = true;
    description = "A serialization and RPC framework";
    homepage = "https://pypi.python.org/pypi/avro-python3/";
    license = licenses.asl20;

    maintainers = [ maintainers.shlevy maintainers.timma ];
  };
}
