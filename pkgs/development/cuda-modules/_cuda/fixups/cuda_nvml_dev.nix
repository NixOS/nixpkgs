{ lib }:
finalAttrs: prevAttrs: {
  # TODO(@connorbaker): Add a setup hook to the outputStubs output to automatically replace rpath entries
  # containing the stubs output with the driver link.

  allowFHSReferences = true;

  # Include the stubs output since it provides libnvidia-ml.so.
  propagatedBuildOutputs = prevAttrs.propagatedBuildOutputs or [ ] ++ [ "stubs" ];

  # TODO: Some programs try to link against libnvidia-ml.so.1, so make an alias.
  # Not sure about the version number though!
  postInstall =
    prevAttrs.postInstall or ""
    + lib.optionalString (lib.elem "stubs" finalAttrs.outputs) ''
      pushd "''${!outputStubs:?}/lib/stubs" >/dev/null
      if [[ -f libnvidia-ml.so && ! -f libnvidia-ml.so.1 ]]; then
        nixLog "creating versioned symlink for libnvidia-ml.so stub"
        ln -sr libnvidia-ml.so libnvidia-ml.so.1
      fi
      if [[ -f libnvidia-ml.a && ! -f libnvidia-ml.a.1 ]]; then
        nixLog "creating versioned symlink for libnvidia-ml.a stub"
        ln -sr libnvidia-ml.a libnvidia-ml.a.1
      fi
      nixLog "creating symlinks for stubs in lib directory"
      ln -srt "''${!outputStubs:?}/lib/" *.so *.so.*
      popd >/dev/null
    '';

  passthru = prevAttrs.passthru or { } // {
    redistBuilderArg = prevAttrs.passthru.redistBuilderArg or { } // {
      outputs = [
        "out"
        "dev"
        "include"
        "stubs"
      ];
    };
  };

  meta = prevAttrs.meta or { } // {
    description = "C-based programmatic interface for monitoring and managing various states within Data Center GPUs";
    longDescription = ''
      The NVIDIA Management Library (NVML) is a C-based programmatic interface for monitoring and managing various
      states within Data Center GPUs. It is intended to be a platform for building 3rd party applications, and is also
      the underlying library for the NVIDIA-supported nvidia-smi tool.
    ''
    + prevAttrs.meta.longDescription;
    homepage = "https://developer.nvidia.com/management-library-nvml";
    downloadPage = "https://developer.download.nvidia.com/compute/cuda/redist/cuda_nvml_dev";
  };
}
