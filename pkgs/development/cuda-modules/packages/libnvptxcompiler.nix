{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "libnvptxcompiler";

  outputs = [ "out" ];

  meta = {
    description = "APIs which can be used to compile a PTX program into GPU assembly code";
    homepage = "https://docs.nvidia.com/cuda/ptx-compiler-api";
  };
}
