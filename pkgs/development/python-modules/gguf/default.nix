{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  poetry-core,
  pythonOlder,
  tqdm,
  pyyaml,
}:
buildPythonPackage rec {
  pname = "gguf";
  version = "0.14.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2ZlvGXp3eDHPngHvrCTL+oF3hzdTBbjE7hYHR3jivOg=";
  };

  dependencies = [
    numpy
    poetry-core
    tqdm
    pyyaml
  ];

  meta = with lib; {
    description = "Module for writing binary files in the GGUF format";
    homepage = "https://ggml.ai/";
    license = licenses.mit;
    maintainers = with maintainers; [ mitchmindtree ];
  };
}
