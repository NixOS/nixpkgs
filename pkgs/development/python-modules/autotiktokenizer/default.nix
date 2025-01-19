{
  lib,
  fetchFromGitHub,
  buildPythonPackage,
  setuptools,
  tiktoken,
  huggingface-hub,
}:

buildPythonPackage rec {
  pname = "autotiktokenizer";
  version = "0.2.1";
  pyproject = true;

  build-system = [ setuptools ];

  src = fetchFromGitHub {
    owner = "bhavnicksm";
    repo = "autotiktokenizer";
    rev = "refs/tags/v${version}";
    hash = "sha256-50rs0wp6nxzoZ/aFB9fW/LcFKSL+OHLTtSxmgqnfCuU=";
  };

  dependencies = [
    tiktoken
    huggingface-hub
  ];

  doCheck = false; # attempt to connect to hugging face

  pythonImportsCheck = [ "autotiktokenizer" ];

  meta = {
    description = "Accelerate your HuggingFace tokenizers by converting them to TikToken format";
    homepage = "https://github.com/bhavnicksm/autotiktokenizer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
}
