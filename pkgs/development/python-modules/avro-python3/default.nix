{ lib, buildPythonPackage, fetchPypi, isPy3k, pycodestyle, isort }:

buildPythonPackage rec {
  pname = "avro-python3";
  version = "1.10.1";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9027abeab63dd9b66bd3c564fa0670c70f78027ecb1978d96c6af7ed415b626b";
  };

  buildInputs = [ pycodestyle isort ];
  doCheck = false;        # No such file or directory: './run_tests.py

  meta = with lib; {
    description = "A serialization and RPC framework";
    homepage = "https://pypi.python.org/pypi/avro-python3/";
    license = licenses.asl20;

    maintainers = [ maintainers.shlevy maintainers.timma ];
  };
}
