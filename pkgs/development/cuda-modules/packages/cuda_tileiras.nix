{
  buildRedist,
  cuda_nvcc,
  lib,
  makeBinaryWrapper,
}:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "cuda_tileiras";

  outputs = [
    "out"
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
  ];

  # tileiras expects to live in a CUDA Toolkit: it dlopens `$ROOT/nvvm/lib64/libnvvm.so` and runs `$ROOT/bin/ptxas`
  # (falling back to PATH), where `$ROOT` is the first of CUDA_ROOT, CUDA_HOME, and CUDA_PATH which is set, or else the
  # parent of the directory containing tileiras. cuda_nvcc provides both in that layout. We use a wrapper instead of
  # symlinking them into our output because CUDA_HOME would take precedence over the latter, and because they would
  # collide with cuda_nvcc's in merged trees like cudatoolkit.
  postInstall = lib.optionalString finalAttrs.finalPackage.meta.available ''
    nixLog "wrapping tileiras to default CUDA_ROOT to ${lib.getBin cuda_nvcc}"
    wrapProgramBinary \
      "''${!outputBin:?}/bin/tileiras" \
      --set-default CUDA_ROOT "${lib.getBin cuda_nvcc}"
  '';

  meta = {
    description = "CUDA Tile IR optimizing assembler";
    longDescription = ''
      `tileiras` compiles CUDA Tile IR bytecode, as produced by frontends like cuTile Python, into a cubin for the GPU
      architecture specified with `--gpu-name`. From CUDA 13.4, the package also provides `tileirdisasm`, which
      disassembles CUDA Tile IR bytecode into a human-readable form.
    '';
    homepage = "https://developer.nvidia.com/cuda/tile";
    mainProgram = "tileiras";
  };
})
