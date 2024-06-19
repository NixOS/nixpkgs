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
    sha256 = "3b63f24e6b04368c3e4a6f923f484be0230d821aad65ac36108edbff29e9aaab";
  };

  buildInputs = [
    pycodestyle
    isort
  ];
  doCheck = false; # No such file or directory: './run_tests.py

  meta = with lib; {
    description = "A serialization and RPC framework";
    mainProgram = "avro";
    homepage = "https://pypi.python.org/pypi/avro-python3/";
    license = licenses.asl20;

    maintainers = [
      maintainers.shlevy
      maintainers.timma
    ];
  };
}
