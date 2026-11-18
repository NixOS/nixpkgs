{
  backendStdenv,
  cmake,
  cuda_cudart,
  cuda_nvcc,
  nvtx,
}:
# Builds programs using NVTX through its CMake package configuration and through FindCUDAToolkit, then runs them with
# an injection library to check the annotations reach the tool.
backendStdenv.mkDerivation {
  __structuredAttrs = true;
  strictDeps = true;

  name = "${nvtx.name}-cmake-test";

  src = ./cmake;

  nativeBuildInputs = [
    cmake
    cuda_nvcc
  ];

  buildInputs = [
    cuda_cudart
    nvtx
  ];

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    checkRange() {
      local -r expected="$1"
      local -r program="$2"
      local output
      output="$(NVTX_INJECTION64_PATH="$out/lib/libinjection.so" "$out/bin/$program")"
      if [[ $output != "$expected" ]]; then
        nixErrorLog "$program: expected '$expected', got '$output'"
        exit 1
      fi
      nixLog "$program: $output"
    }

    checkRange "nvtxRangePushA: interop" interop
    checkRange "nvtxDomainRangePushEx: range" package-config
    checkRange "nvtxDomainRangePushEx: range" cuda-toolkit

    runHook postInstallCheck
  '';
}
