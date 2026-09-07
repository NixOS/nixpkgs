{
  lib,
  stdenv,
  llvm_meta,
  release_version,
  monorepoSrc,
  runCommand,
  cmake,
  ninja,
  llvm,
  lit,
  clang-unwrapped,
  lld,
  python3,
  version,
  openmp,
  cudaSupport ? false,
  cudaPackages,
  rocmSupport ? false,
  rocmPackages,
}:

assert lib.assertMsg (
  !(cudaSupport && rocmSupport)
) "cudaSupport and rocmSupport are mutually exclusive";

# The offload project (libomptarget) was split out of the openmp directory
# starting with LLVM 19.  For LLVM 18 it is still built as part of openmp.
assert lib.assertMsg (lib.versionAtLeast release_version "19")
  "offload package is only available for LLVM 19+; use openmp for LLVM 18";

stdenv.mkDerivation (finalAttrs: {
  pname = "offload";
  inherit version;

  src =
    runCommand "${finalAttrs.pname}-src-${finalAttrs.version}"
      {
        inherit (monorepoSrc) passthru;
      }
      ''
        mkdir -p "$out"
        cp -r ${monorepoSrc}/cmake "$out"
        cp -r ${monorepoSrc}/offload "$out"
        cp -r ${monorepoSrc}/openmp "$out"
        cp -r ${monorepoSrc}/libc "$out"
        cp -r ${monorepoSrc}/third-party "$out"
        cp -r ${monorepoSrc}/runtimes "$out"
      '';

  sourceRoot = "${finalAttrs.src.name}/offload";

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
    python3
    ninja
    lit
  ]
  ++ lib.optionals (cudaSupport || rocmSupport) [
    lld
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ]
  ++ lib.optionals rocmSupport [
    rocmPackages.rocm-device-libs
  ];

  buildInputs = [
    llvm
    openmp
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    cudaPackages.cccl
  ]
  ++ lib.optionals rocmSupport [
    rocmPackages.rocm-runtime
    rocmPackages.rocm-device-libs
  ];

  # Prevent setupCudaHook from overriding the host compiler — the
  # libomptarget build uses clang (via CLANG_TOOL) for device code, not nvcc.
  dontSetupCUDAToolkitCompilers = cudaSupport;

  # When GPU offloading is enabled, the DeviceRTL build invokes clang
  # directly via the CLANG_TOOL cmake variable to compile device-side
  # bitcode.  For LLVM 19+, clang's resource directory headers (stdint.h,
  # stddef.h, etc.) live in the lib output, separate from the binary in
  # the out output.  clang searches for its resource directory relative
  # to the binary at <bindir>/../lib/clang/<version>/, which doesn't
  # exist when the binary and headers are in different store paths.
  #
  # We create a directory where bin/clang and lib/clang/<version>/ coexist
  # via symlinks, so clang finds its resource directory through the default
  # relative path — no wrapper script needed.
  clangForOffload =
    if cudaSupport || rocmSupport then
      runCommand "clang-with-resource-dir" { } ''
        mkdir -p $out/bin $out/lib/clang/${lib.versions.major version}
        ln -s ${clang-unwrapped}/bin/clang $out/bin/clang
        ln -s ${lib.getLib clang-unwrapped}/lib/clang/${lib.versions.major version}/include \
          $out/lib/clang/${lib.versions.major version}/include
      ''
    else
      clang-unwrapped;

  cmakeFlags = [
    (lib.cmakeFeature "CLANG_TOOL" "${finalAttrs.finalPackage.clangForOffload}/bin/clang")
    (lib.cmakeFeature "OPT_TOOL" "${llvm}/bin/opt")
    (lib.cmakeFeature "LINK_TOOL" "${llvm}/bin/llvm-link")
    (lib.cmakeFeature "PACKAGER_TOOL" "${clang-unwrapped}/bin/clang-offload-packager")
    (lib.cmakeFeature "LIBOMP_INCLUDE_DIR" "${openmp.dev}/include")
    (lib.cmakeFeature "LIBOMP_LIBRARY_DIR" "${lib.getLib openmp}/lib")
    (lib.cmakeBool "OFFLOAD_INCLUDE_TESTS" false)
  ]
  ++ lib.optionals cudaSupport [
    (lib.cmakeFeature "LIBOMPTARGET_DEVICE_ARCHITECTURES" (
      lib.concatStringsSep ";" (
        map (cap: "sm_" + lib.replaceStrings [ "." ] [ "" ] cap) cudaPackages.flags.cudaCapabilities
      )
    ))
    (lib.cmakeFeature "CMAKE_CUDA_ARCHITECTURES" cudaPackages.flags.cmakeCudaArchitecturesString)
  ]
  ++ lib.optionals rocmSupport [
    (lib.cmakeFeature "LIBOMPTARGET_DEVICE_ARCHITECTURES" (
      lib.concatStringsSep ";" rocmPackages.clr.gpuTargets
    ))
    (lib.cmakeFeature "DEVICELIBS_ROOT" "${rocmPackages.rocm-device-libs}/amdgcn/bitcode")
  ];

  doCheck = false;

  checkTarget = "check-offload";

  meta = llvm_meta // {
    homepage = "https://openmp.llvm.org/";
    description = "LLVM OpenMP offloading runtime (libomptarget)";
    longDescription = ''
      The offload subproject of LLVM contains the libomptarget runtime library
      that supports OpenMP target offloading to devices such as NVIDIA CUDA
      (NVPTX) and AMD (AMDGPU) GPUs.
    ''
    + lib.optionalString cudaSupport ''
      This build includes GPU offloading support for NVIDIA CUDA (NVPTX).
    ''
    + lib.optionalString rocmSupport ''
      This build includes GPU offloading support for AMD (AMDGPU).
    '';
    license = with lib.licenses; [
      mit
      ncsa
    ];
  };
})
