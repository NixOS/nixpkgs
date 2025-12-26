{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "nvidia_fs";

  outputs = [ "out" ];

  allowFHSReferences = true;

  meta = {
    description = "GPUDirect Storage kernel driver to read/write data from supported storage using cufile APIs";
    longDescription = ''
      GPUDirect Storage kernel driver nvidia-fs.ko is a kernel module to orchestrate IO directly from DMA/RDMA
      capable storage to user allocated GPU memory on NVIDIA Graphics cards.
    '';
    homepage = "https://github.com/NVIDIA/gds-nvidia-fs";
    changelog = "https://github.com/NVIDIA/gds-nvidia-fs/releases";
  };
}
