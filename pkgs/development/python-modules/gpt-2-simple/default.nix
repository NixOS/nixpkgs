{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  regex,
  requests,
  setuptools,
  tqdm,
  numpy,
  toposort,
  tensorflow,
}:

buildPythonPackage rec {
  pname = "gpt-2-simple";
  version = "0.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "minimaxir";
    repo = "gpt-2-simple";
    rev = "v${version}";
    hash = "sha256-WwD4sDcc28zXEOISJsq8e+rgaNrrgIy79Wa4J3E7Ovc=";
  };

  build-system = [ setuptools ];

  propagatedBuildInputs = [
    regex
    requests
    tqdm
    numpy
    toposort
    tensorflow
  ];

  doCheck = false; # no tests in upstream

  meta = with lib; {
    description = "Easily retrain OpenAI's GPT-2 text-generating model on new texts";
    homepage = "https://github.com/minimaxir/gpt-2-simple";
    license = licenses.mit;
    maintainers = [ ];
  };
}
