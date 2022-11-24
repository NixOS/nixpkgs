{ lib
, stdenv
, fetchFromGitHub
, writeScript
, cmake
, rocm-cmake
, rocm-opencl-runtime
, clang
, texlive ? null
, doxygen ? null
, sphinx ? null
, python3Packages ? null
, openblas ? null
, buildDocs ? false
, buildTests ? false
, buildBenchmarks ? false
}:

assert buildDocs -> texlive != null;
assert buildDocs -> doxygen != null;
assert buildDocs -> sphinx != null;
assert buildDocs -> python3Packages != null;
assert buildTests -> openblas != null;

let
  latex = lib.optionalAttrs buildDocs (texlive.combine {
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
  });
in stdenv.mkDerivation (finalAttrs: {
  pname = "miopengemm";
  rocmVersion = "5.3.3";
  version = finalAttrs.rocmVersion;

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "docs"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildBenchmarks [
    "benchmark"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "MIOpenGEMM";
    rev = "rocm-${finalAttrs.rocmVersion}";
    hash = "sha256-AiRzOMYRA/0nbQomyq4oOEwNZdkPYWRA2W6QFlctvFc=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clang
  ];

  buildInputs = [
    rocm-opencl-runtime
  ] ++ lib.optionals buildDocs [
    latex
    doxygen
    sphinx
    python3Packages.sphinx_rtd_theme
    python3Packages.breathe
  ] ++ lib.optionals buildTests [
    openblas
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=clang"
    "-DCMAKE_CXX_COMPILER=clang++"
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

  postInstall = lib.optionalString buildTests ''
    mkdir -p $test/bin
    find tests -executable -type f -exec mv {} $test/bin \;
    patchelf --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs}:$out/lib $test/bin/*
  '' + lib.optionalString buildBenchmarks ''
    mkdir -p $benchmark/bin
    find examples -executable -type f -exec mv {} $benchmark/bin \;
    patchelf --set-rpath ${lib.makeLibraryPath finalAttrs.buildInputs}:$out/lib $benchmark/bin/*
  '';

  postFixup = lib.optionalString buildDocs ''
    mkdir -p $docs/share/doc/miopengemm
    mv ../doc/html $docs/share/doc/miopengemm
    mv ../doc/pdf/miopengemm.pdf $docs/share/doc/miopengemm
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    rocmVersion="$(curl -sL "https://api.github.com/repos/ROCmSoftwarePlatform/MIOpenGEMM/releases?per_page=1" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version miopengemm "$rocmVersion" --ignore-same-hash --version-key=rocmVersion
  '';

  meta = with lib; {
    description = "OpenCL general matrix multiplication API for ROCm";
    homepage = "https://github.com/ROCmSoftwarePlatform/MIOpenGEMM";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.rocmVersion != clang.version;
  };
})
