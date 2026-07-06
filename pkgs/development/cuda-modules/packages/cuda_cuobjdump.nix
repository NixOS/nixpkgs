{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_cuobjdump";
  outputs = [ "out" ];

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
}
