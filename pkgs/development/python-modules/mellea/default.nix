{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  pdm-backend,

  # dependencies
  pydantic,
  openai,
  jinja2,
  json5,
  ollama,
  ansicolors,
  requests,
  uvicorn,
  fastapi,
  types-requests,
  types-tqdm,
  typer,
  click,
  mistletoe,
  huggingface-hub,

  # tests
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "mellea";
  version = "0.0.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "generative-computing";
    repo = "mellea";
    tag = version;
    hash = "sha256-ruH2JJMkBQcPusfN3eH5+nKjRvzGOXUqQMRORaUyb/U=";
  };

  build-system = [
    pdm-backend
  ];

  dependencies = [
    pydantic
    openai
    jinja2
    json5
    ollama
    ansicolors
    requests
    uvicorn
    fastapi
    types-requests
    types-tqdm
    typer
    click
    mistletoe
    huggingface-hub
  ];

  pythonImportsCheck = [
    "mellea"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # Skip running tests because they require all optional dependencies,
  # many of which are not available in nixpkgs yet.
  doCheck = false;

  meta = {
    changelog = "https://github.com/generative-computing/mellea/blob/${src.tag}/CHANGELOG.md";
    description = "Library for writing generative programs";
    homepage = "https://github.com/generative-computing/mellea";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ codgician ];
  };
}
