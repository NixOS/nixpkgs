{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pycodestyle,
  isort,
}:

buildPythonPackage rec {
  pname = "avro-python3";
  version = "1.10.2";
  format = "setuptools";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-O2PyTmsENow+Sm+SP0hL4CMNghqtZaw2EI7b/ynpqqs=";
  };

  buildInputs = [
    pycodestyle
    isort
  ];
  doCheck = false; # No such file or directory: './run_tests.py

  meta = with lib; {
    description = "Serialization and RPC framework";
    mainProgram = "avro";
    homepage = "https://pypi.python.org/pypi/avro-python3/";
    license = licenses.asl20;

    maintainers = [
      maintainers.shlevy
      maintainers.timma
    ];
  };
}
