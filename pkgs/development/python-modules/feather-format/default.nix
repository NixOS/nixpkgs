{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  pyarrow,
}:

buildPythonPackage rec {
  pname = "feather-format";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;

    hash = "sha256-RfZ+N0XTlNTxYMptY2u/1Pi2jQEZncFkm25IfT6HiQM=";
  };

  build-system = [ setuptools ];
  dependencies = [ pyarrow ];

  pythonImportsCheck = [ "feather" ];
  doCheck = false; # no tests

  meta = {
    description = "Simple wrapper library to the Apache Arrow-based Feather File Format";
    homepage = "https://github.com/wesm/feather";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
