{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-vcs,
  hatchling,
  pythonOlder,
  accelerate,
  bentoml,
  dulwich,
  nvidia-ml-py,
  openai,
  psutil,
  pyaml,
  questionary,
  tabulate,
  typer,
  uv,
}:

buildPythonPackage rec {
  pname = "openllm";
  version = "0.6.10";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "bentoml";
    repo = "openllm";
    rev = "refs/tags/v${version}";
    hash = "sha256-4KIpe6KjbBDDUj0IjzSccxjgZyBoaUVIQJYk1+W01Vo=";
  };

  pythonRemoveDeps = [
    "pathlib"
    "pip-requirements-parser"
  ];

  pythonRelaxDeps = [ "openai" ];

  build-system = [
    hatch-vcs
    hatchling
  ];

  dependencies = [
    accelerate
    bentoml
    dulwich
    nvidia-ml-py
    openai
    psutil
    pyaml
    questionary
    tabulate
    typer
    uv
  ];

  # no tests
  doCheck = false;

  pythonImportsCheck = [ "openllm" ];

  meta = with lib; {
    description = "Run any open-source LLMs, such as Llama 3.1, Gemma, as OpenAI compatible API endpoint in the cloud";
    homepage = "https://github.com/bentoml/OpenLLM";
    changelog = "https://github.com/bentoml/OpenLLM/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [
      happysalada
      natsukium
    ];
    mainProgram = "openllm";
  };
}
