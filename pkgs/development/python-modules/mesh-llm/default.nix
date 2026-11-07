{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch2,
  hatchling,
  mesh-llm-ffi,
  pytestCheckHook,
  writableTmpDirAsHomeHook,
}:

# nixpkgs-update: no auto update
# Tied to mesh-llm release / mesh-llm-ffi.
buildPythonPackage (finalAttrs: {
  pname = "mesh-llm";
  # The SDK has no releases or tags; pyproject.toml says 0.76.1.
  version = "0-unstable-2026-11-01";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "Mesh-LLM";
    repo = "mesh-llm-python-sdk";
    rev = "acaf6fe9e5d899321988203cabfbab97eedf5c7e";
    hash = "sha256-jnjGwlx3A1IY2maymm2eFhQPmUL1NJ9O4zidRfsRaIg=";
  };

  sourceRoot = "${finalAttrs.src.name}/sdk";

  patches = [
    # Yield one event loop turn after installing native runtime on Python 3.13+;
    # from the open https://github.com/Mesh-LLM/mesh-llm-python-sdk/pull/6.
    (fetchpatch2 {
      name = "deliver-native-runtime-progress-before-install-returns.patch";
      url = "https://github.com/Mesh-LLM/mesh-llm-python-sdk/commit/db696ea33494919159bac7eb42cd98ca72bb8af2.patch?full_index=1";
      hash = "sha256-aZNfbU7ssS0bCC3py6+QbSn7fRv3zI6OV1S4HjhafhQ=";
      stripLen = 1;
      includes = [ "src/**" ];
    })
  ];

  build-system = [
    hatchling
  ];

  preBuild = ''
    mkdir -p src/meshllm/_generated
    cp ${mesh-llm-ffi}/lib/libmeshllm_ffi${stdenv.hostPlatform.extensions.sharedLibrary} \
      src/meshllm/_generated/libuniffi${stdenv.hostPlatform.extensions.sharedLibrary}
  '';

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ];

  # Some tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;
  # On Darwin, iroh's interface detection reaches CoreFoundation APIs that read
  # ICU data from the system and segfault without it, as for mesh-llm; the
  # tests start an embedded node.
  sandboxProfile = ''
    (allow file-read* (subpath "/usr/share/icu"))
  '';

  pythonImportsCheck = [ "meshllm" ];

  meta = {
    description = "Python SDK and in-process native node for the MeshLLM mesh";
    homepage = "https://github.com/Mesh-LLM/mesh-llm-python-sdk";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ kleinbem ];
  };
})
