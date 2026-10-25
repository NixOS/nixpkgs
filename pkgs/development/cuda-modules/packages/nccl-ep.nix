{
  _cuda,
  backendStdenv,
  cudaAtLeast,
  cudaNamePrefix,
  cudaOlder,
  lib,

  # nativeBuildInputs
  autoAddDriverRunpath,
  cuda_nvcc,
  which,

  # buildInputs
  cccl,
  cuda_crt ? null, # only exists in cudaPackages with CUDA >= 13.0
  cuda_cudart,
  nccl,
}:

let
  epFlags = _cuda.lib.formatCapabilities {
    inherit (_cuda.db) cudaCapabilityToInfo;
    inherit (backendStdenv) cudaForwardCompat;
    cudaCapabilities = lib.filter (
      cudaCapability: lib.versionAtLeast cudaCapability "9.0"
    ) backendStdenv.cudaCapabilities;
  };
in

backendStdenv.mkDerivation (finalAttrs: {
  name = "${cudaNamePrefix}-${finalAttrs.pname}-${finalAttrs.version}";
  pname = "nccl-ep";
  inherit (nccl) src version;
  sourceRoot = "${finalAttrs.src.name}/contrib/nccl_ep";

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    autoAddDriverRunpath
    cuda_nvcc
    which
  ];

  buildInputs = [
    cccl
    cuda_cudart
    (lib.getLib nccl)
  ]

  ++ lib.optionals (cudaOlder "13.0") [ (lib.getInclude cuda_nvcc) ]
  ++ lib.optionals (cudaAtLeast "13.0") [ cuda_crt ];

  makeFlags = [
    "CUDA_HOME=${lib.getBin cuda_nvcc}"
    "CUDA_INC=${lib.getInclude cuda_cudart}/include"
    "CUDA_LIB=${lib.getLib cuda_cudart}/lib"
    "LDFLAGS=-L${lib.getLib cuda_cudart}/lib/stubs"
    "NCCL_INCDIR=${lib.getInclude nccl}/include"
    "NCCL_LIBDIR=${lib.getLib nccl}/lib"
    "NCCL_EP_BUILDDIR=${placeholder "out"}"
  ]
  ++ lib.optionals (epFlags.cudaCapabilities != [ ]) [ "NVCC_GENCODE=${epFlags.gencodeString}" ];
  buildFlags = [ "lib" ];

  installPhase = ''
    runHook preInstall

    rm -rf "$out/obj"

    ln -s ${lib.getInclude nccl}/include/nccl.h "$out/include/nccl.h"
    ln -s ${lib.getInclude nccl}/include/nccl_device.h "$out/include/nccl_device.h"
    ln -s ${lib.getInclude nccl}/include/nccl_device "$out/include/nccl_device"

    runHook postInstall
  '';

  meta = {
    description = "Expert-parallelism (MoE dispatch/combine) extension library for NCCL";
    homepage = "https://github.com/NVIDIA/nccl/blob/master/contrib/nccl_ep/README.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thefossguy ];
    inherit (nccl.meta) platforms badPlatforms;
  };
})
