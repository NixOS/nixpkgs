{ lib
, buildPythonPackage
, fetchPypi
, numpy
, poetry-core
, pythonOlder
}:
buildPythonPackage rec {
  pname = "gguf";
  version = "0.6.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-suIuq6KhBsGtFIGGoUrZ8pxCk1Fob+nXzhbfOaBgfmU=";
  };

  dependencies = [
    numpy
    poetry-core
  ];

  doCheck = false;

  meta = with lib; {
    description = "A module for writing binary files in the GGUF format";
    homepage = "https://ggml.ai/";
    license = licenses.mit;
    maintainers = with maintainers; [ mitchmindtree ];
  };
}
