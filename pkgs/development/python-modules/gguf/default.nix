{
  lib,
  buildPythonPackage,
  fetchPypi,
  numpy,
  poetry-core,
  pythonOlder,
  tqdm,
}:
buildPythonPackage rec {
  pname = "gguf";
  version = "0.9.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9ecJh+FbGcVF9qn3UztAM/swYzDrHzxclf0osUw/0zs=";
  };

  dependencies = [
    numpy
    poetry-core
    tqdm
  ];

  meta = with lib; {
    description = "Module for writing binary files in the GGUF format";
    homepage = "https://ggml.ai/";
    license = licenses.mit;
    maintainers = with maintainers; [ mitchmindtree ];
  };
}
