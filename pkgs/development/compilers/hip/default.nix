{ lib
, stdenv
, fetchFromGitHub
, fetchpatch
, rocmUpdateScript
, substituteAll
, makeWrapper
, hip-common
, hipcc
, rocclr
, roctracer
, cmake
, perl
, llvm
, rocminfo
, rocm-thunk
, rocm-comgr
, rocm-device-libs
, rocm-runtime
, rocm-opencl-runtime
, cudatoolkit
, numactl
, libxml2
, libX11
, libglvnd
, doxygen
, graphviz
, fontconfig
, python3Packages
, buildDocs ? true
, buildTests ? false
, useNVIDIA ? false
}:

let
  hipPlatform = if useNVIDIA then "nvidia" else "amd";

  wrapperArgs = [
    "--prefix PATH : $out/bin"
    "--prefix LD_LIBRARY_PATH : ${rocm-runtime}"
    "--set HIP_PLATFORM ${hipPlatform}"
    "--set HIP_PATH $out"
    "--set HIP_CLANG_PATH ${stdenv.cc}/bin"
    "--set DEVICE_LIB_PATH ${rocm-device-libs}/amdgcn/bitcode"
    "--set HSA_PATH ${rocm-runtime}"
    "--set ROCM_PATH $out"
  ] ++ lib.optionals useNVIDIA [
    "--set CUDA_PATH ${cudatoolkit}"
  ];
in stdenv.mkDerivation (finalAttrs: {
  pname = "hip-${hipPlatform}";
  version = "5.4.2";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "ROCm-Developer-Tools";
    repo = "hipamd";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-FcuylhkG7HqLYXH1J6ND6IVEIbDzHp7h7jg2ZZ4XoFM=";
  };

  patches = [
    (substituteAll {
      src = ./0000-fixup-paths.patch;
      inherit llvm;
      clang = stdenv.cc;
      rocm_runtime = rocm-runtime;
    })

    # https://github.com/ROCm-Developer-Tools/hipamd/commit/be33ec55acc104a59d01df5912261d007c7f3ee9
    (fetchpatch {
      url = "https://github.com/ROCm-Developer-Tools/hipamd/commit/be33ec55acc104a59d01df5912261d007c7f3ee9.patch";
      hash = "sha256-eTC4mUIN1FwRce1n38uDOlITFL/vpcOhvnaZTo5R7lo=";
    })
  ];

  nativeBuildInputs = [
    makeWrapper
    cmake
    perl
    python3Packages.python
    python3Packages.cppheaderparser
  ] ++ lib.optionals buildDocs [
    doxygen
    graphviz
    fontconfig
  ];

  buildInputs = [
    numactl
    libxml2
    libX11
    libglvnd
  ];

  propagatedBuildInputs = [
    stdenv.cc
    llvm
    rocminfo
    rocm-thunk
    rocm-comgr
    rocm-device-libs
    rocm-runtime
    rocm-opencl-runtime
  ] ++ lib.optionals useNVIDIA [
    cudatoolkit
  ];

  cmakeFlags = [
    "-DROCM_PATH=${rocminfo}"
    "-DHIP_PLATFORM=${hipPlatform}"
    "-DHIP_COMMON_DIR=${hip-common}"
    "-DHIPCC_BIN_DIR=${hipcc}/bin"
    "-DHIP_LLVM_ROOT=${stdenv.cc}"
    "-DROCCLR_PATH=${rocclr}"
    "-DAMD_OPENCL_PATH=${rocm-opencl-runtime.src}"
    "-DPROF_API_HEADER_PATH=${roctracer.src}/inc/ext"
    # Temporarily set variables to work around upstream CMakeLists issue
    # Can be removed once https://github.com/ROCm-Developer-Tools/hipamd/issues/55 is fixed
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ] ++ lib.optionals buildTests [
    "-DHIP_CATCH_TEST=1"
  ];

  postPatch = ''
    export HIP_CLANG_PATH=${stdenv.cc}/bin
    patchShebangs src
  '' + lib.optionalString buildDocs ''
    export HOME=$(mktemp -d)
    export FONTCONFIG_FILE=${fontconfig.out}/etc/fonts/fonts.conf
  '';

  doCheck = buildTests;
  checkTarget = "build_tests";

  preCheck = lib.optionalString buildTests ''
    export ROCM_PATH=$PWD
    export DEVICE_LIB_PATH=${rocm-device-libs}/amdgcn/bitcode
    patchShebangs bin
  '';

  postInstall = ''
    patchShebangs $out/bin
    cp -a $out/bin/hipcc $out/bin/hipcc-pl
    cp -a $out/bin/hipconfig $out/bin/hipconfig-pl
    wrapProgram $out/bin/hipcc --set HIP_USE_PERL_SCRIPTS 0
    wrapProgram $out/bin/hipconfig --set HIP_USE_PERL_SCRIPTS 0
    wrapProgram $out/bin/hipcc.bin ${lib.concatStringsSep " " wrapperArgs}
    wrapProgram $out/bin/hipconfig.bin ${lib.concatStringsSep " " wrapperArgs}
    wrapProgram $out/bin/hipcc-pl --set HIP_USE_PERL_SCRIPTS 1
    wrapProgram $out/bin/hipconfig-pl --set HIP_USE_PERL_SCRIPTS 1
    wrapProgram $out/bin/hipcc.pl ${lib.concatStringsSep " " wrapperArgs}
    wrapProgram $out/bin/hipconfig.pl ${lib.concatStringsSep " " wrapperArgs}
  '';

  passthru = {
    # All known and valid general GPU targets
    # We cannot use this for each ROCm library, as each defines their own supported targets
    # See: https://github.com/RadeonOpenCompute/ROCm/blob/77cbac4abab13046ee93d8b5bf410684caf91145/README.md#library-target-matrix
    gpuTargets = lib.forEach [
      "803"
      "900"
      "906"
      "908"
      "90a"
      "1010"
      "1012"
      "1030"
    ] (target: "gfx${target}");

    updateScript = rocmUpdateScript {
      name = finalAttrs.pname;
      owner = finalAttrs.src.owner;
      repo = finalAttrs.src.repo;
    };
  };

  meta = with lib; {
    description = "C++ Heterogeneous-Compute Interface for Portability specifically for AMD platform";
    homepage = "https://github.com/ROCm-Developer-Tools/hipamd";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ lovesegfault ] ++ teams.rocm.members;
    platforms = platforms.linux;
    # Tests require GPU, also include issues
    broken =
      versions.minor finalAttrs.version != versions.minor hip-common.version ||
      versions.minor finalAttrs.version != versions.minor hipcc.version ||
      buildTests;
  };
})
