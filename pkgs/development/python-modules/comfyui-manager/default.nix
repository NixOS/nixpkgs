{
  lib,
  buildPythonPackage,
  fetchPypi,
  setuptools,
  chardet,
  gitpython,
  huggingface-hub,
  pygithub,
  rich,
  toml,
  transformers,
  typer,
  typing-extensions,
  uv,
  comfyui,
}:

buildPythonPackage (finalAttrs: {
  pname = "comfyui-manager";
  version = "4.2.2";
  pyproject = true;

  src = fetchPypi {
    pname = "comfyui_manager";
    inherit (finalAttrs) version;
    hash = "sha256-7kjoOOetsHroQzLpu0+nvzZFVkNwxGz4qHBviNA0G8Y=";
  };

  build-system = [ setuptools ];

  dependencies = [
    chardet
    gitpython
    huggingface-hub
    pygithub
    rich
    toml
    transformers
    typer
    typing-extensions
    uv
  ];

  # `comfyui_manager/__init__.py` imports `comfy.cli_args` at module-load
  # time — that only resolves inside a running ComfyUI process, so a regular
  # `import comfyui_manager` cannot succeed in isolation.
  doCheck = false;

  meta = {
    description = "Custom-node manager extension for ComfyUI";
    homepage = "https://github.com/ltdrdata/ComfyUI-Manager";
    license = lib.licenses.gpl3Only;
    mainProgram = "cm-cli";
    inherit (comfyui.meta) maintainers;
  };
})
