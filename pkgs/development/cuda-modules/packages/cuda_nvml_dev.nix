{ buildRedist, lib }:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "cuda_nvml_dev";

  outputs = [
    "out"
    "dev"
    "include"
    "stubs"
  ];

  # TODO(@connorbaker): Add a setup hook to the outputStubs output to automatically replace rpath entries
  # containing the stubs output with the driver link.

  allowFHSReferences = true;

  # Include the stubs output since it provides libnvidia-ml.so.
  propagatedBuildOutputs = lib.optionals (lib.elem "stubs" finalAttrs.outputs) [ "stubs" ];

  # TODO: Some programs try to link against libnvidia-ml.so.1, so make an alias.
  # Not sure about the version number though!
  postInstall = lib.optionalString (lib.elem "stubs" finalAttrs.outputs) ''
    pushd "''${!outputStubs:?}/lib/stubs" >/dev/null
    if [[ -f libnvidia-ml.so && ! -f libnvidia-ml.so.1 ]]; then
      nixLog "creating versioned symlink for libnvidia-ml.so stub"
      ln -sr libnvidia-ml.so libnvidia-ml.so.1
    fi
    if [[ -f libnvidia-ml.a && ! -f libnvidia-ml.a.1 ]]; then
      nixLog "creating versioned symlink for libnvidia-ml.a stub"
      ln -sr libnvidia-ml.a libnvidia-ml.a.1
    fi
    popd >/dev/null
  '';

  meta = {
    description = "C-based programmatic interface for monitoring and managing various states within Data Center GPUs";
    longDescription = ''
      The NVIDIA Management Library (NVML) is a C-based programmatic interface for monitoring and managing various
      states within Data Center GPUs. It is intended to be a platform for building 3rd party applications, and is also
      the underlying library for the NVIDIA-supported nvidia-smi tool.
    '';
    homepage = "https://developer.nvidia.com/management-library-nvml";
  };
})
