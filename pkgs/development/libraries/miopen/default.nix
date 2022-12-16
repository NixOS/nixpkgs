{ lib
, stdenv
, fetchFromGitHub
, fetchurl
, rocmUpdateScript
, pkg-config
, cmake
, rocm-cmake
, rocm-runtime
, rocm-device-libs
, rocm-comgr
, rocm-opencl-runtime
, rocblas
, rocmlir
, hip
, clang
, clang-ocl
, llvm
, miopengemm
, composable_kernel
, half
, boost
, sqlite
, bzip2
, nlohmann_json
, texlive
, doxygen
, sphinx
, zlib
, python3Packages
, buildDocs ? true
, buildTests ? false
# LFS isn't working, so we will manually fetch these
# This isn't strictly required, but is recommended to enable
# https://github.com/ROCmSoftwarePlatform/MIOpen/issues/1373
#
# MIOpen will produce a very large output due to KDBs fetched
# Also possibly in the future because of KDB generation
# This is disabled by default so we can cache on hydra
, fetchKDBs ? false
, useOpenCL ? false
}:

let
  latex = lib.optionalAttrs buildDocs texlive.combine {
    inherit (texlive) scheme-small
    latexmk
    tex-gyre
    fncychap
    wrapfig
    capt-of
    framed
    needspace
    tabulary
    varwidth
    titlesec;
  };

  kdbs = lib.optionalAttrs fetchKDBs import ./deps.nix {
    inherit fetchurl;
    mirror = "https://repo.radeon.com/rocm/miopen-kernel/rel-5.0";
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "miopen";
  version = "5.4.0";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ] ++ lib.optionals buildTests [
    "test"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "MIOpen";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-EOe3LUafOeVLzRoahPdS6DMZ/+6WWeVI7jG25zfPrx8=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    rocm-cmake
    hip
    clang
    llvm
  ];

  buildInputs = [
    rocm-runtime
    rocm-device-libs
    rocm-comgr
    rocm-opencl-runtime
    rocblas
    rocmlir
    clang-ocl
    miopengemm
    composable_kernel
    half
    boost
    sqlite
    bzip2
    nlohmann_json
  ] ++ lib.optionals buildDocs [
    latex
    doxygen
    sphinx
    python3Packages.sphinx-rtd-theme
    python3Packages.breathe
    python3Packages.myst-parser
  ] ++ lib.optionals buildTests [
    zlib
  ];

  cmakeFlags = [
    "-DMIOPEN_USE_MIOPENGEMM=ON"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals (!useOpenCL) [
    "-DCMAKE_C_COMPILER=hipcc"
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DMIOPEN_BACKEND=HIP"
  ] ++ lib.optionals useOpenCL [
    "-DCMAKE_C_COMPILER=${clang}/bin/clang"
    "-DCMAKE_CXX_COMPILER=${clang}/bin/clang++"
    "-DMIOPEN_BACKEND=OpenCL"
  ] ++ lib.optionals buildTests [
    "-DBUILD_TESTS=ON"
    "-DMIOPEN_TEST_ALL=ON"
    "-DMIOPEN_TEST_GFX900=ON"
    "-DMIOPEN_TEST_GFX906=ON"
    "-DMIOPEN_TEST_GFX908=ON"
    "-DMIOPEN_TEST_GFX90A=ON"
    "-DMIOPEN_TEST_GFX103X=ON"
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "enable_testing()" "" \
      --replace "MIOPEN_HIP_COMPILER MATCHES \".*clang\\\\+\\\\+$\"" "true" \
      --replace "/opt/rocm/hip" "${hip}" \
      --replace "/opt/rocm/llvm" "${llvm}" \
      --replace "3 REQUIRED PATHS /opt/rocm)" "3 REQUIRED PATHS ${hip})" \
      --replace "hip REQUIRED PATHS /opt/rocm" "hip REQUIRED PATHS ${hip}" \
      --replace "rocblas REQUIRED PATHS /opt/rocm" "rocblas REQUIRED PATHS ${rocblas}" \
      --replace "miopengemm PATHS /opt/rocm" "miopengemm PATHS ${miopengemm}" \
      --replace "set(MIOPEN_TIDY_ERRORS ALL)" "" # Fix clang-tidy at some point
  '' + lib.optionalString (!buildTests) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(test)" ""
  '' + lib.optionalString fetchKDBs ''
    cp -a ${kdbs.gfx1030_36} src/kernels/gfx1030_36.kdb
    cp -a ${kdbs.gfx900_56} src/kernels/gfx900_56.kdb
    cp -a ${kdbs.gfx900_64} src/kernels/gfx900_64.kdb
    cp -a ${kdbs.gfx906_60} src/kernels/gfx906_60.kdb
    cp -a ${kdbs.gfx906_64} src/kernels/gfx906_64.kdb
    cp -a ${kdbs.gfx90878} src/kernels/gfx90878.kdb
    cp -a ${kdbs.gfx90a68} src/kernels/gfx90a68.kdb
    cp -a ${kdbs.gfx90a6e} src/kernels/gfx90a6e.kdb
  '';

  # Unfortunately, it seems like we have to call make on these manually
  postBuild = lib.optionalString buildDocs ''
    export HOME=$(mktemp -d)
    make doc
  '' + lib.optionalString buildTests ''
    make -j$NIX_BUILD_CORES check
  '';

  postInstall = ''
    rm $out/bin/install_precompiled_kernels.sh
  '' + lib.optionalString buildDocs ''
    mv ../doc/html $out/share/doc/miopen-${if useOpenCL then "opencl" else "hip"}
    mv ../doc/pdf/miopen.pdf $out/share/doc/miopen-${if useOpenCL then "opencl" else "hip"}
  '' + lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv bin/test_* $test/bin
    patchelf --set-rpath ${lib.makeLibraryPath (finalAttrs.buildInputs ++ [ hip ])}:$out/lib $test/bin/*
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Machine intelligence library for ROCm";
    homepage = "https://github.com/ROCmSoftwarePlatform/MIOpen";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.version != hip.version;
  };
})
