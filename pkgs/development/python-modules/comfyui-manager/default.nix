{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  aiohttp,
  chardet,
  gitpython,
  huggingface-hub,
  packaging,
  pydantic,
  pygithub,
  pyyaml,
  requests,
  rich,
  toml,
  tqdm,
  transformers,
  typer,
  typing-extensions,
  uv,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-manager";
  version = "4.2.1";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_manager";
    inherit (finalAttrs) version;
    hash = "sha256-x3dH937Y0+gGAEQAYh0Rk3MktBnmHMFs95QbgAMkRvc=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    chardet
    gitpython
    huggingface-hub
    packaging
    pydantic
    pygithub
    pyyaml
    requests
    rich
    toml
    tqdm
    transformers
    typer
    typing-extensions
    uv
  ];

  # `comfyui_manager/__init__.py` imports `comfy.cli_args` at module-load
  # time — that only resolves inside a running ComfyUI process, so a regular
  # `import comfyui_manager` cannot succeed in isolation.
  doCheck = false;
  pythonImportsCheck = [ ];

  meta = {
    description = "Custom-node manager extension for ComfyUI";
    homepage = "https://github.com/ltdrdata/ComfyUI-Manager";
    license = lib.licenses.gpl3Only;
    mainProgram = "cm-cli";
    maintainers = with lib.maintainers; [ caniko ];
  };
})
