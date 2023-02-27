{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, pkg-config
, cmake
, rocm-cmake
, hip
, clang-tools-extra
, openmp
, rocblas
, rocmlir
, miopengemm
, miopen
, protobuf
, half
, nlohmann_json
, msgpack
, sqlite
, oneDNN
, blaze
, texlive
, doxygen
, sphinx
, docutils
, ghostscript
, python3Packages
, buildDocs ? false
, buildTests ? false
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
    titlesec
    epstopdf;
  };
in stdenv.mkDerivation (finalAttrs: {
  pname = "migraphx";
  version = "5.4.2";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ] ++ lib.optionals buildTests [
    "test"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "AMDMIGraphX";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-UDhm+j9qs4Rk81C1PE4kkacytfY2StYbfsCOtFL+p6s=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
    rocm-cmake
    hip
    clang-tools-extra
    python3Packages.python
  ] ++ lib.optionals buildDocs [
    latex
    doxygen
    sphinx
    docutils
    ghostscript
    python3Packages.sphinx-rtd-theme
    python3Packages.breathe
  ];

  buildInputs = [
    openmp
    rocblas
    rocmlir
    miopengemm
    miopen
    protobuf
    half
    nlohmann_json
    msgpack
    sqlite
    oneDNN
    blaze
    python3Packages.pybind11
    python3Packages.onnx
  ];

  cmakeFlags = [
    "-DCMAKE_POLICY_DEFAULT_CMP0079=NEW"
    # "-DCMAKE_C_COMPILER=hipcc"
    # "-DCMAKE_CXX_COMPILER=hipcc"
    "-DMIGRAPHX_ENABLE_GPU=OFF" # GPU compilation is broken, don't know why
    "-DMIGRAPHX_ENABLE_CPU=ON"
    "-DMIGRAPHX_ENABLE_FPGA=ON"
    "-DMIGRAPHX_ENABLE_MLIR=ON"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ];

  postPatch = ''
    patchShebangs tools

    substituteInPlace src/targets/gpu/CMakeLists.txt \
      --replace "CMAKE_CXX_COMPILER MATCHES \".*clang\\\+\\\+\$\"" "TRUE"
  '' + lib.optionalString (!buildDocs) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(doc)" ""
  '' + lib.optionalString (!buildTests) ''
    substituteInPlace CMakeLists.txt \
      --replace "add_subdirectory(test)" ""
  '';

  # Unfortunately, it seems like we have to call make on this manually
  preInstall = lib.optionalString buildDocs ''
    export HOME=$(mktemp -d)
    make -j$NIX_BUILD_CORES doc
    cd ../doc/pdf
    make -j$NIX_BUILD_CORES
    cd -
  '';

  postInstall = lib.optionalString buildDocs ''
    mv ../doc/html $out/share/doc/migraphx
    mv ../doc/pdf/MIGraphX.pdf $out/share/doc/migraphx
  '' + lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv bin/test_* $test/bin
    patchelf $test/bin/test_* --shrink-rpath --allowed-rpath-prefixes /nix/store
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "AMD's graph optimization engine";
    homepage = "https://github.com/ROCmSoftwarePlatform/AMDMIGraphX";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    platforms = platforms.linux;
    broken = versions.minor finalAttrs.version != versions.minor hip.version;
  };
})
