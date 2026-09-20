{
  buildRedist,
  cuda_nvdisasm,
  lib,
  makeBinaryWrapper,
}:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "cuda_cuobjdump";
  outputs = [ "out" ];

  nativeBuildInputs = [ makeBinaryWrapper ];

  # cuobjdump delegates SASS disassembly to nvdisasm at runtime.
  postFixup = lib.optionalString finalAttrs.finalPackage.meta.available ''
    wrapProgram "''${!outputBin:?}/bin/cuobjdump" \
      --set-default NVDISASM_PATH ${lib.makeBinPath [ cuda_nvdisasm ]}
  '';

  meta = {
    description = "Extracts information from CUDA binary files (both standalone and those embedded in host binaries) and presents them in human readable format";
    longDescription = ''
      `cuobjdump` extracts information from CUDA binary files (both standalone and those embedded in host binaries)
      and presents them in human readable format. The output of cuobjdump includes CUDA assembly code for each kernel,
      CUDA ELF section headers, string tables, relocators and other CUDA specific sections. It also extracts embedded
      ptx text from host binaries.
    '';
    homepage = "https://docs.nvidia.com/cuda/cuda-binary-utilities#cuobjdump";
  };
})
