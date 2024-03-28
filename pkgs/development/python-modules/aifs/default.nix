{ lib
, buildPythonPackage
, fetchFromGitHub
, poetry-core
, chromadb
, unstructured
}:

buildPythonPackage {
  pname = "aifs";
  # versions are not tagged on github yet
  version = "0.0.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "OpenInterpreter";
    repo = "aifs";
    rev = "912547bfa576f4f8b9f8908b15179173376d630e";
    hash = "sha256-ki84Ls14jcL6OrvFZmmZfQKReVg/yKqDLXXumVsLrsY=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    chromadb
    unstructured
  ];

  pythonImportsCheck = [ "aifs" ];

  meta = with lib; {
    description = "Local semantic search. Stupidly simple";
    homepage = "https://github.com/OpenInterpreter/aifs";
    license = with licenses; [ asl20 mit ];
    maintainers = with maintainers; [ happysalada ];
  };
}
