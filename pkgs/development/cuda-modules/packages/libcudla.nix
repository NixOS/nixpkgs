{
  backendStdenv,
  buildRedist,
  lib,
}:
buildRedist {
  redistName = "cuda";
  pname = "libcudla";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "stubs"
  ];

  autoPatchelfIgnoreMissingDeps = lib.optionals backendStdenv.hasJetsonCudaCapability [
    "libnvcudla.so"
  ];
}
