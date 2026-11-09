{
  buildRedist,
  cudaOlder,
  lib,
  liburcu,
  numactl,
  rdma-core,
  systemdLibs,
  util-linux,
}:
buildRedist {
  redistName = "cuda";
  pname = "libcufile";

  outputs = [
    "out"
    "dev"
    "include"
    "lib"
    "static"
  ];

  allowFHSReferences = true;

  # TODO(@connorbaker): At some point before 12.6, libcufile depends on libcublas.
  buildInputs = [
    numactl
    rdma-core
  ];

  # dlopen'd by libcufile.so, which is why the buildInputs above do not cover it. Note the
  # unversioned sonames: the providing output must carry the .so symlink.
  appendRunpaths = map (pkg: "${lib.getLib pkg}/lib") [
    systemdLibs # libudev.so
    util-linux # libmount.so
    liburcu # liburcu-bp.so, liburcu-cds.so
    numactl # libnuma.so.%s
  ];

  # Before 11.7 libcufile depends on itself for some reason.
  autoPatchelfIgnoreMissingDeps = [
    "libcuda.so.1"
  ]
  ++ lib.optionals (cudaOlder "11.7") [ "libcufile.so.0" ];

  meta = {
    description = "Library to leverage GDS technology";
    homepage = "https://docs.nvidia.com/gpudirect-storage/api-reference-guide";
  };
}
