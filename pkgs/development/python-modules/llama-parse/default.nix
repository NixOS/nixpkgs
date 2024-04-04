{ lib
, buildPythonPackage
, fetchPypi
, llama-index-core
, poetry-core
, pythonOlder
}:

buildPythonPackage rec {
  pname = "llama-parse";
  version = "0.4.0";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "llama_parse";
    inherit version;
    hash = "sha256-7lIelCLbSNvfADA8tukPEGYTGWC1yk4U9bWm22t5F+I=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    llama-index-core
  ];

  pythonImportsCheck = [
    "llama_parse"
  ];

  meta = with lib; {
    description = "Parse files into RAG-Optimized formats";
    homepage = "https://pypi.org/project/llama-parse/";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
