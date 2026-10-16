{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  huggingface-hub,
  kernels-data,
  packaging,
  pyyaml,
  tomlkit,
}:
buildPythonPackage (finalAttrs: {
  pname = "kernels";
  version = "0.15.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "huggingface";
    repo = "kernels";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NyFVWaJat5uwT8edzyIQuPfleVP+hg45an+rux6bIfo=";
  };

  sourceRoot = "${finalAttrs.src.name}/kernels";

  build-system = [
    setuptools
  ];

  dependencies = [
    huggingface-hub
    kernels-data
    packaging
    pyyaml
    tomlkit
  ];

  # Tests require pervasive internet access
  doCheck = false;

  pythonImportsCheck = [ "kernels" ];

  meta = {
    description = "Load compute kernels from the Huggingface Hub";
    homepage = "https://github.com/huggingface/kernels";
    changelog = "https://github.com/huggingface/kernels/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ osbm ];
  };
})
