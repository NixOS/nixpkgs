{
  autoAddDriverRunpath,
  autoreconfHook,
  backendStdenv,
  cuda_cudart,
  cuda_nvcc,
  cudaNamePrefix,
  cudaOlder,
  fetchFromGitHub,
  lib,
  patchelf,
  rdma-core,
  ucx,
  # passthru.updateScript
  unstableGitUpdater,

  withUcx ? true,
}:
let
  inherit (lib)
    getDev
    getInclude
    licenses
    maintainers
    optionals
    teams
    ;
in
backendStdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  strictDeps = true;

  # NOTE: Depends on the CUDA package set, so use cudaNamePrefix.
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "nccl-rdma-sharp-plugins";
  # The last tag (v2.1.0) dates back to 2020; releases are only cut through HPC-X / DOCA-OFED.
  version = "2.7-unstable-2026-08-11";

  src = fetchFromGitHub {
    owner = "Mellanox";
    repo = "nccl-rdma-sharp-plugins";
    rev = "7daa9c64a2c496804c1d7a9284ca55b699716036";
    hash = "sha256-rgcf/cUyYzuCLC/zJchvl4wP2N2yQxjMZbL/L4+86Dk=";
  };

  nativeBuildInputs = [
    # cudart_static dlopens libcuda.so.1 by bare soname.
    autoAddDriverRunpath
    autoreconfHook
    # Used by src/Makefile.am's install-exec-hook to set the SONAME of libnccl-net-ibext.so.
    patchelf
  ];

  buildInputs = [
    cuda_cudart
    rdma-core
  ]
  # cuda_runtime.h includes crt/host_config.h, which lives in cuda_nvcc before CUDA 13.
  ++ optionals (cudaOlder "13.0") [ (getInclude cuda_nvcc) ]
  ++ optionals withUcx [ ucx ];

  configureFlags = [
    "--with-cuda=${getDev cuda_cudart}"
    "--with-verbs=${getDev rdma-core}"
    (if withUcx then "--with-ucx=${getDev ucx}" else "--without-ucx")
    # SHARP (libsharp_coll) is only distributed through HPC-X / DOCA-OFED and is not packaged.
    "--without-sharp"
  ];

  enableParallelBuilding = true;

  postInstall = ''
    find "$out/lib" -name '*.la' -delete
  '';

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "RDMA and SHARP network plugins for NCCL";
    longDescription = ''
      Provides libnccl-net.so, an NCCL network plugin implementing InfiniBand verbs and UCX
      transports. Point NCCL to it with NCCL_NET_PLUGIN or by adding it to LD_LIBRARY_PATH.
    '';
    homepage = "https://github.com/Mellanox/nccl-rdma-sharp-plugins";
    license = licenses.bsd3;
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    maintainers = with maintainers; [ GaetanLepage ];
    teams = [ teams.cuda ];
  };
})
