_: prevAttrs: {
  allowFHSReferences = true;

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [ "out" ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "GPUDirect Storage kernel driver to read/write data from supported storage using cufile APIs";
    longDescription = ''
      GPUDirect Storage kernel driver nvidia-fs.ko is a kernel module to orchestrate IO directly from DMA/RDMA
      capable storage to user allocated GPU memory on NVIDIA Graphics cards.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://github.com/NVIDIA/gds-nvidia-fs";
    changelog = "https://github.com/NVIDIA/gds-nvidia-fs/releases";
  };
}
