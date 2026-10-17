{
  lib,
  stdenv,
  llvm_meta,
  release_version,
  monorepoSrc ? null,
  src ? null,
  runCommand,
  cmake,
  ninja,
  llvm,
  lit,
  clang-unwrapped,
  perl,
  pkg-config,
  python3,
  version,
  devExtraCmakeFlags ? [ ],
  ompdSupport ? true,
  ompdGdbSupport ? ompdSupport,
  getVersionFile,
  checkPhaseThreadLimitHook,
  cudaSupport ? false,
  cudaPackages,
  rocmSupport ? false,
  rocmPackages,
}:

assert lib.assertMsg (ompdGdbSupport -> ompdSupport) "OMPD GDB support requires OMPD support!";
assert lib.assertMsg (
  !(cudaSupport && rocmSupport)
) "cudaSupport and rocmSupport are mutually exclusive";

stdenv.mkDerivation (finalAttrs: {
  pname = "openmp";
  inherit version;

  src =
    if monorepoSrc != null then
      runCommand "openmp-src-${version}"
        {
          inherit (monorepoSrc) passthru;
          strictDeps = true;
          __structuredAttrs = true;
        }
        ''
          mkdir -p "$out"
          cp -r ${monorepoSrc}/cmake "$out"
          cp -r ${monorepoSrc}/openmp "$out"
        ''
    else
      src;

  sourceRoot = "${finalAttrs.src.name}/openmp";

  outputs = [
    "out"
    "dev"
  ];

  patches =
    lib.optional (lib.versionOlder release_version "19") (getVersionFile "openmp/fix-find-tool.patch")
    ++ [
      (getVersionFile "openmp/run-lit-directly.patch")
    ];

  nativeBuildInputs = [
    cmake
    python3
    perl
    ninja
    pkg-config
    lit
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_nvcc
  ]
  ++ lib.optionals rocmSupport [
    rocmPackages.rocm-device-libs
  ];

  propagatedNativeBuildInputs = [
    checkPhaseThreadLimitHook
  ];

  buildInputs = [
    llvm
  ]
  ++ lib.optionals (ompdSupport && ompdGdbSupport) [
    python3
  ]
  ++ lib.optionals cudaSupport [
    cudaPackages.cuda_cudart
    cudaPackages.cccl
  ]
  ++ lib.optionals rocmSupport [
    rocmPackages.rocm-runtime
    rocmPackages.rocm-device-libs
  ];

  strictDeps = true;

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
    (lib.cmakeBool "LIBOMP_ENABLE_SHARED" (
      !stdenv.hostPlatform.isStatic && stdenv.hostPlatform.hasSharedLibraries
    ))
    (lib.cmakeBool "LIBOMP_OMPD_SUPPORT" ompdSupport)
    (lib.cmakeBool "LIBOMP_OMPD_GDB_SUPPORT" ompdGdbSupport)
    (lib.cmakeFeature "CLANG_TOOL" "${finalAttrs.finalPackage.clangForOffload}/bin/clang")
    (lib.cmakeFeature "OPT_TOOL" "${llvm}/bin/opt")
    (lib.cmakeFeature "LINK_TOOL" "${llvm}/bin/llvm-link")
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
  ]
  ++ devExtraCmakeFlags;

  doCheck = false;

  checkTarget = "check-openmp";

  preCheck = ''
    patchShebangs ../tools/archer/tests/deflake.bash
  '';

  __structuredAttrs = true;

  meta = llvm_meta // {
    homepage = "https://openmp.llvm.org/";
    description = "Support for the OpenMP language";
    longDescription = ''
      The OpenMP subproject of LLVM contains the components required to build an
      executable OpenMP program that are outside the compiler itself.
      Contains the code for the runtime library against which code compiled by
      "clang -fopenmp" must be linked before it can run and the library that
      supports offload to target devices.
    ''
    + lib.optionalString cudaSupport ''
      This build includes GPU offloading support for NVIDIA CUDA (NVPTX).
    ''
    + lib.optionalString rocmSupport ''
      This build includes GPU offloading support for AMD (AMDGPU).
    '';
    # "All of the code is dual licensed under the MIT license and the UIUC
    # License (a BSD-like license)":
    license = with lib.licenses; [
      mit
      ncsa
    ];
  };
})
