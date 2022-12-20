{ lib
, stdenv
, fetchFromGitHub
, rocmUpdateScript
, cmake
, rocm-cmake
, hip
, openmp
, gtest
, rocblas
, texlive
, doxygen
, sphinx
, python3Packages
, buildDocs ? true
, buildTests ? false
, buildSamples ? false
, gpuTargets ? [ ] # gpuTargets = [ "gfx908:xnack-" "gfx90a:xnack-" "gfx90a:xnack+" ... ]
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
  pname = "rocwmma";
  version = "5.4.0";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildSamples [
    "sample"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocWMMA";
    rev = "rocm-${finalAttrs.version}";
    hash = "sha256-HUJPb6IahBgl/v+W4kXludBTNAjRm8k6v0jxKAX+qZM=";
  };

  patches = lib.optionals buildTests [
    ./0000-dont-fetch-googletest.patch
  ];

  nativeBuildInputs = [
    cmake
    rocm-cmake
    hip
  ];

  buildInputs = [
    openmp
  ] ++ lib.optionals buildTests [
    gtest
    rocblas
  ] ++ lib.optionals buildDocs [
    latex
    doxygen
    sphinx
    python3Packages.sphinx-rtd-theme
    python3Packages.breathe
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_COMPILER=hipcc"
    "-DROCWMMA_BUILD_TESTS=${if buildTests then "ON" else "OFF"}"
    "-DROCWMMA_BUILD_SAMPLES=${if buildSamples then "ON" else "OFF"}"
    # Manually define CMAKE_INSTALL_<DIR>
    # See: https://github.com/NixOS/nixpkgs/pull/197838
    "-DCMAKE_INSTALL_BINDIR=bin"
    "-DCMAKE_INSTALL_LIBDIR=lib"
    "-DCMAKE_INSTALL_INCLUDEDIR=include"
  ] ++ lib.optionals (gpuTargets != [ ]) [
    "-DGPU_TARGETS=${lib.concatStringsSep ";" gpuTargets}"
  ] ++ lib.optionals buildTests [
    "-DROCWMMA_BUILD_VALIDATION_TESTS=ON"
    "-DROCWMMA_BUILD_BENCHMARK_TESTS=ON"
    "-DROCWMMA_BUILD_EXTENDED_TESTS=ON"
    "-DROCWMMA_VALIDATE_WITH_ROCBLAS=ON"
    "-DROCWMMA_BENCHMARK_WITH_ROCBLAS=ON"
  ];

  postPatch = lib.optionalString buildDocs ''
    patchShebangs docs/*.sh
  '';

  # Unfortunately, it seems like we have to call make on this manually
  # -DROCWMMA_BUILD_DOCS=ON is invalid, despite being on the README
  postBuild = lib.optionalString buildDocs ''
    export HOME=$(mktemp -d)
    ../docs/run_doc.sh
  '';

  postInstall = lib.optionalString buildDocs ''
    mv ../docs/source/_build/html $out/share/doc/rocwmma
    mv ../docs/source/_build/latex/rocWMMA.pdf $out/share/doc/rocwmma
  '' + lib.optionalString buildTests ''
    mkdir -p $test/bin
    mv $out/bin/*_test* $test/bin
  '' + lib.optionalString buildSamples ''
    mkdir -p $sample/bin
    mv $out/bin/sgemmv $sample/bin
    mv $out/bin/simple_gemm $sample/bin
    mv $out/bin/simple_dlrm $sample/bin
  '' + lib.optionalString (buildTests || buildSamples) ''
    rmdir $out/bin
  '';

  passthru.updateScript = rocmUpdateScript {
    name = finalAttrs.pname;
    owner = finalAttrs.src.owner;
    repo = finalAttrs.src.repo;
  };

  meta = with lib; {
    description = "Mixed precision matrix multiplication and accumulation";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocWMMA";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    # Building tests isn't working for now
    # undefined reference to symbol '_ZTIN7testing4TestE'
    broken = finalAttrs.version != hip.version || buildTests;
  };
})
