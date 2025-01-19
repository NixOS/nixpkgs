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
  version = "0.10.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UqMO8mMotBn/xH2SafxYDCOO3xyKGbXqFDwyPgSgOME=";
  };

  dependencies = [
    numpy
    poetry-core
    tqdm
    pyyaml
  ];

  meta = {
    description = "Module for writing binary files in the GGUF format";
    homepage = "https://ggml.ai/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mitchmindtree ];
  };
}
