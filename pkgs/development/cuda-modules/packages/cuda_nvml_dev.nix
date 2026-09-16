{
  addDriverRunpath,
  buildRedist,
  cudaMajorMinorVersion,
}:
buildRedist (finalAttrs: {
  redistName = "cuda";
  pname = "cuda_nvml_dev";

  outputs = [
    "out"
    "dev"
    "include"
    "stubs"
  ];

  # NVML's driver library is a stub even when its output is collapsed or renamed.
  includeRemoveStubsFromRunpathHook = true;

  allowFHSReferences = true;

  # Include the stubs output since it provides libnvidia-ml.so.
  propagatedBuildOutputs = [ finalAttrs.outputStubs ];

  # The module appends /stubs to libdir; NVML has no separate runtime library.
  # Direct pkg-config consumers also need the driver before any stub RUNPATH
  # added by the compiler wrapper, without relying on stdenv's fixup hooks.
  postPatch = ''
    substituteInPlace share/pkgconfig/nvidia-ml-${cudaMajorMinorVersion}.pc \
      --replace-fail "libdir=''${!outputLib:?}/lib" "libdir=''${!outputStubs:?}/lib" \
      --replace-fail '-lnvidia-ml' '-lnvidia-ml -Wl,-rpath,${addDriverRunpath.driverLink}/lib'
  '';

  # Consumers which search by NVML's SONAME also need a versioned stub alias.
  postInstall = ''
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
