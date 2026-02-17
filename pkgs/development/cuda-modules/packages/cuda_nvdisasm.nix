{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_nvdisasm";

  outputs = [ "out" ];

  meta = {
    description = "Extracts information from standalone cubin files and presents them in human readable format";
    longDescription = ''
      `nvdisasm` extracts information from standalone cubin files and presents them in human readable format. The
      output of `nvdisasm` includes CUDA assembly code for each kernel, listing of ELF data sections and other CUDA
      specific sections. Output style and options are controlled through `nvdisasm` command-line options. `nvdisasm`
      also does control flow analysis to annotate jump/branch targets and makes the output easier to read.
    '';
    homepage = "https://docs.nvidia.com/cuda/cuda-binary-utilities#nvdisasm";
  };
}
