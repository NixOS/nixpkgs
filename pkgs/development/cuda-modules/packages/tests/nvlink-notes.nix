{
  backendStdenv,
  cuda_cudart,
  cuda_cuobjdump,
  cuda_nvcc,
  cudaAtLeast,
  cudaConfig,
  cudaNamePrefix,
  lib,
  libffi,
}:
let
  arch = lib.replaceStrings [ "." ] [ "" ] (lib.head cudaConfig.cudaCapabilities);
  # NVCC runs on BUILD. Its store path must not reach a HOST output, whatever
  # the spelling of the path, so match the hash rather than the name.
  buildNvcc = cuda_nvcc.__spliced.buildHost or cuda_nvcc;
  buildNvccHash = builtins.substring 11 32 (toString buildNvcc);
in
# nvlink records its command line, including its library search paths, in the
# .note.nv.tkinfo section of each cubin it writes. NVCC embeds those cubins in the
# linked program's fatbin. CUDA 13 writes the note for every architecture.
backendStdenv.mkDerivation {
  name = "${cudaNamePrefix}-tests-nvlink-notes";
  __structuredAttrs = true;
  strictDeps = true;
  dontUnpack = true;
  dontStrip = true;
  outputs = [
    "out"
    "notes"
  ];

  nativeBuildInputs = [
    cuda_nvcc
    cuda_cuobjdump
  ];
  # libffi is never linked. Its library directory reaches nvlink only through
  # the NVCC wrapper's library search paths, so its presence in the note shows
  # what the wrapper forwards.
  buildInputs = [
    cuda_cudart
    libffi
  ];

  # Nix does not find references inside compressed fatbins. Keep them visible to
  # disallowedRequisites as well as to the cuobjdump check below.
  dontCompressCudaFatbins = true;

  buildPhase = ''
    runHook preBuild
    cat > caller.cu <<'EOF'
    extern __device__ int answer();
    __global__ void kernel(int *out) { *out = answer(); }
    int main() { int *d = nullptr; cudaMalloc(&d, sizeof(int)); kernel<<<1, 1>>>(d); return cudaDeviceSynchronize(); }
    EOF
    echo '__device__ int answer() { return 42; }' > answer.cu

    nvcc -arch=sm_${arch} -rdc=true caller.cu answer.cu -o rdc
    nvcc -arch=sm_${arch} -rdc=true -dlto caller.cu answer.cu -o rdc-lto

    mkdir -p "$notes"
    local program
    for program in rdc rdc-lto; do
      cuobjdump -elf "$program" | grep -E 'Tool (Name|Command Line)' > "$notes/$program.txt" || true
    done

    # Checked here rather than in checkPhase, which cross builds skip: nothing
    # here runs on HOST.
    ${lib.optionalString (cudaAtLeast "13.0") ''
      if ! grep -qF 'Tool Name: nvlink' "$notes/rdc.txt"; then
        nixErrorLog "rdc has no nvlink note; the check below would be vacuous"
        exit 1
      fi
    ''}
    if grep -F '${buildNvccHash}' "$notes/rdc.txt"; then
      nixErrorLog "nvlink recorded a path from NVCC's own package in a relocatable device link"
      exit 1
    fi
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 rdc "$out/bin/rdc"
    runHook postInstall
  '';

  disallowedRequisites = [ buildNvcc ];

  meta.description = "Check the store paths nvlink records in relocatable device links";
}
