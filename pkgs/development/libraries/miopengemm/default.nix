{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, rocm-opencl-runtime
, texlive
, doxygen
, sphinx
, openblas
, python3Packages
, buildDocs ? true
, buildTests ? false
, buildBenchmarks ? false
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
in stdenv.mkDerivation (finalAttrs: {
  pname = "miopengemm";
  version = "5.4.1";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildBenchmarks [
    "benchmark"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "MIOpenGEMM";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-AiRzOMYRA/0nbQomyq4oOEwNZdkPYWRA2W6QFlctvFc=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
  ];

  buildInputs = [
    rocm-opencl-runtime
  ] ++ lib.optionals buildDocs [
    latex
    doxygen
    sphinx
    python3Packages.sphinx-rtd-theme
    python3Packages.breathe
  ] ++ lib.optionals buildTests [
    openblas
  ];

  cmakeFlags = [
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals buildTests [
    "-DOPENBLAS=ON"
  ] ++ lib.optionals buildBenchmarks [
    "-DAPI_BENCH_MIOGEMM=ON"
    # Needs https://github.com/CNugteren/CLBlast
    # "-DAPI_BENCH_CLBLAST=ON"
    # Needs https://github.com/openai/triton
    # "-DAPI_BENCH_ISAAC=ON"
  ];

  # Unfortunately, it seems like we have to call make on these manually
  postBuild = lib.optionalString buildDocs ''
    export HOME=$(mktemp -d)
    make doc
  '' + lib.optionalString buildTests ''
    make check
  '' + lib.optionalString buildBenchmarks ''
    make examples
  '';

  postInstall = lib.optionalString buildDocs ''
    mv ../doc/html $out/share/doc/miopengemm
    mv ../doc/pdf/miopengemm.pdf $out/share/doc/miopengemm
  '' + lib.optionalString buildTests ''
    mkdir -p $test/bin
    find tests -executable -type f -exec mv {} $test/bin \;
    patchelf --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs}:$out/lib $test/bin/*
  '' + lib.optionalString buildBenchmarks ''
    mkdir -p $benchmark/bin
    find examples -executable -type f -exec mv {} $benchmark/bin \;
    patchelf --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs}:$out/lib $benchmark/bin/*
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "OpenCL general matrix multiplication API for ROCm";
    homepage = "https://github.com/ROCmSoftwarePlatform/MIOpenGEMM";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = versions.minor finalAttrs.version != versions.minor stdenv.cc.version;
  };
})
