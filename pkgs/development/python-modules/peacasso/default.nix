{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  setuptools-scm,
  accelerate,
  diffusers,
  fastapi,
  ftfy,
  pydantic,
  scipy,
  torch,
  transformers,
  typer,
  uvicorn,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "peacasso";
  version = "0.0.19a0";
  pyproject = true;

  # No releases or tags are available in https://github.com/victordibia/peacasso
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-qBoG9FAJs0oZrQ0jShtPZfZPmyUZD30MGXDUfMl5bQk=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    accelerate
    diffusers
    fastapi
    ftfy
    pydantic
    scipy
    torch
    transformers
    typer
    uvicorn
  ];

  pythonRelaxDeps = [ "diffusers" ];

  pythonImportsCheck = [
    "peacasso"
  ];

  # No tests
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "UI tool to help you generate art (and experiment) with multimodal (text, image) AI models (stable diffusion)";
    homepage = "https://github.com/victordibia/peacasso";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "peacasso";
  };
}
