{ lib
, buildPythonPackage
, fetchPypi
, poetry-core
, langchain-core
, lxml
, pythonOlder
}:

buildPythonPackage rec {
  pname = "langchain-text-splitters";
  version = "0.0.1";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchPypi {
    pname = "langchain_text_splitters";
    inherit version;
    hash = "sha256-rEWfqYeZ9RF61UJakzCyGWEyHjC8GaKi+fdh3a3WKqE=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    langchain-core
    lxml
  ];

  # PyPI source does not have tests
  doCheck = false;

  pythonImportsCheck = [
    "langchain_text_splitters"
  ];

  meta = with lib; {
    description = "Build context-aware reasoning applications";
    homepage = "https://github.com/langchain-ai/langchain/tree/master/libs/text-splitters";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
