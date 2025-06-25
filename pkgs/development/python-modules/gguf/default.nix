{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,
  numpy,
  poetry-core,
  pyyaml,
  sentencepiece,
  tqdm,
}:
buildPythonPackage rec {
  pname = "gguf";
  version = "0.17.1";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Nq1xqtkAo+dfyU6+lupgKfA6TkS+difvetPQPox7y1M=";
  };

  dependencies = [
    numpy
    poetry-core
    pyyaml
    sentencepiece
    tqdm
  ];

  pythonImportsCheck = [ "gguf" ];

  meta = with lib; {
    description = "Module for writing binary files in the GGUF format";
    homepage = "https://ggml.ai/";
    license = licenses.mit;
    maintainers = with maintainers; [ mitchmindtree ];
  };
}
