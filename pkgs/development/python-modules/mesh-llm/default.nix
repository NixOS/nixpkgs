{
  lib,
  stdenv,
  buildPythonPackage,
  hatchling,
  mesh-llm-ffi,
  pytestCheckHook,
}:

# nixpkgs-update: no auto update
# Follows the mesh-llm release, which mesh-llm's update script updates.
buildPythonPackage {
  pname = "mesh-llm";
  # The SDK ships with each MeshLLM release but has its own version
  # (mesh/sdk/python/pyproject.toml). Its generated bindings must match
  # mesh-llm-ffi's native library, so it builds from the same release source.
  version = "0.76.1";
  inherit (mesh-llm-ffi) src;
  pyproject = true;

  sourceRoot = "${mesh-llm-ffi.src.name}/mesh/sdk/python";

  build-system = [
    hatchling
  ];

  preBuild = ''
    cp ${mesh-llm-ffi}/lib/libmeshllm_ffi${stdenv.hostPlatform.extensions.sharedLibrary} \
      src/meshllm/_generated/libuniffi${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # The tests put src/ first on sys.path; without it they import the installed package.
  preCheck = ''
    rm -r src
  '';

  pythonImportsCheck = [ "meshllm" ];

  meta = {
    description = "Python SDK and in-process native node for the MeshLLM mesh";
    longDescription = ''
      Client mode needs no model runtime. To serve models, set the variables in
      `mesh-llm.passthru.runtimeEnvironment` (`MESH_LLM_NATIVE_RUNTIME_BUNDLE_DIR`)
      to use the runtimes built by Nixpkgs; upstream's prebuilt runtimes don't run
      on NixOS.
    '';
    homepage = "https://github.com/Mesh-LLM/mesh-llm/tree/main/mesh/sdk/python";
    inherit (mesh-llm-ffi.meta) changelog platforms;
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
  };
}
