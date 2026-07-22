{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPy3k,
  pycodestyle,
  isort,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "avro-python3";
  version = "1.10.2";
  pyproject = true;
  disabled = !isPy3k;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-O2PyTmsENow+Sm+SP0hL4CMNghqtZaw2EI7b/ynpqqs=";
  };

  build-system = [ setuptools ];

  buildInputs = [
    pycodestyle
    isort
  ];
  doCheck = false; # No such file or directory: './run_tests.py

  meta = {
    description = "Serialization and RPC framework";
    mainProgram = "avro";
    homepage = "https://pypi.org/project/avro-python3/";
    license = lib.licenses.asl20;

    maintainers = [
      lib.maintainers.shlevy
      lib.maintainers.timma
    ];
  };
})
