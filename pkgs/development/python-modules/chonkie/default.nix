{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  autotiktokenizer,
  numpy,
  sentence-transformers,
  model2vec,
}:

buildPythonPackage rec {
  pname = "chonkie";
  version = "0.2.1.post1";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "bhavnicksm";
    repo = "chonkie";
    rev = "refs/tags/v${version}";
    hash = "sha256-L5tNQkch7m68yEFTA3O424oIACvrGW6ELkHedkJkVxs=";
  };

  dependencies = [
    autotiktokenizer
    numpy
    sentence-transformers
    model2vec
  ];

  doCheck = false; # test requires internet

  pythonImportsCheck = [ "chonkie" ];

  meta = {
    description = "No-nonsense RAG chunking library";
    homepage = "https://github.com/konradhalas/dacite";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
