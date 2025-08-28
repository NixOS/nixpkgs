_: prevAttrs: {
  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "Extracts information from CUDA binary files (both standalone and those embedded in host binaries) and presents them in human readable format";
    longDescription = ''
      `cuobjdump` extracts information from CUDA binary files (both standalone and those embedded in host binaries)
      and presents them in human readable format. The output of cuobjdump includes CUDA assembly code for each kernel,
      CUDA ELF section headers, string tables, relocators and other CUDA specific sections. It also extracts embedded
      ptx text from host binaries.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://docs.nvidia.com/cuda/cuda-binary-utilities#cuobjdump";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_cuobjdump";
  };
}
