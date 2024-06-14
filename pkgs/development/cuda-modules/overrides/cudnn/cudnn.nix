{
  cudaOlder,
  cudaPackages,
  lib,
  patchelf,
  zlib,
}:
let
  inherit (lib)
    lists
    maintainers
    meta
    strings
    ;
  inherit (cudaPackages) cudatoolkit libcublas;
in
finalAttrs: prevAttrs:
let
  inherit (finalAttrs.passthru) useCudatoolkitRunfile;
in
{
  buildInputs =
    prevAttrs.buildInputs
    ++ [ zlib ]
    ++ lists.optionals useCudatoolkitRunfile [ cudatoolkit ]
    # NOTE: Verions of CUDNN after 9.0 no longer depend on libcublas:
    # https://docs.nvidia.com/deeplearning/cudnn/latest/release-notes.html?highlight=cublas#cudnn-9-0-0
    # However, NVIDIA only provides libcublasLT via the libcublas package.
    ++ lists.optionals (!useCudatoolkitRunfile) [ libcublas.lib ];

  # Tell autoPatchelf about runtime dependencies.
  # NOTE: Versions from CUDNN releases have four components.
  postFixup =
    strings.optionalString
      (
        strings.versionAtLeast finalAttrs.version "8.0.0.0"
        && strings.versionOlder finalAttrs.version "9.0.0.0"
      )
      ''
        ${meta.getExe' patchelf "patchelf"} $lib/lib/libcudnn.so --add-needed libcudnn_cnn_infer.so
        ${meta.getExe' patchelf "patchelf"} $lib/lib/libcudnn_ops_infer.so --add-needed libcublas.so --add-needed libcublasLt.so
      '';

  passthru = prevAttrs.meta // {
    useCudatoolkitRunfile = cudaOlder "11.4";
  };

  meta = prevAttrs.meta // {
    homepage = "https://developer.nvidia.com/cudnn";
    maintainers =
      prevAttrs.meta.maintainers
      ++ (with maintainers; [
        mdaiter
        samuela
        connorbaker
      ]);
    license = {
      shortName = "cuDNN EULA";
      fullName = "NVIDIA cuDNN Software License Agreement (EULA)";
      url = "https://docs.nvidia.com/deeplearning/sdk/cudnn-sla/index.html#supplement";
      free = false;
      redistributable = !useCudatoolkitRunfile;
    };
  };
}
