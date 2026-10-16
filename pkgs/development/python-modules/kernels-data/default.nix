{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  kernels,

  # build-system
  rustPlatform,

  # dependencies
  huggingface-hub,
  kernels-data,
  packaging,
  pyyaml,
  tomlkit,
}:
buildPythonPackage (finalAttrs: {
  pname = "kernels-data";
  inherit (kernels) src version;
  pyproject = true;
  __structuredAttrs = true;

  # sourceRoot = "${finalAttrs.src.name}/kernels-data/bindings/python";
  buildAndTestSubdir = "kernels-data/bindings/python";

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      # sourceRoot
      ;
    hash = "sha256-zcgxnQfEPEqBMoNe6yqFhGyfVhrgaao56Rwcm9J3Fi8=";
  };

  build-system = [
    rustPlatform.maturinBuildHook
  ];

  dependencies = [
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
