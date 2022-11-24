{ lib
, stdenv
, fetchFromGitHub
, writeScript
, cmake
, rocm-cmake
, hip
, openmp
, gtest ? null
, rocblas ? null
, texlive ? null
, doxygen ? null
, sphinx ? null
, python3Packages ? null
, buildTests ? false
, buildSamples ? false
, buildDocs ? false
, gpuTargets ? null # gpuTargets = [ "gfx908:xnack-" "gfx90a:xnack-" "gfx90a:xnack+" ... ]
}:

assert buildTests -> gtest != null;
assert buildTests -> rocblas != null;
assert buildDocs -> texlive != null;
assert buildDocs -> doxygen != null;
assert buildDocs -> sphinx != null;
assert buildDocs -> python3Packages != null;

# Building tests isn't working for now
# undefined reference to symbol '_ZTIN7testing4TestE'
assert buildTests == false;

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
  pname = "rocwmma";
  repoVersion = "0.8";
  rocmVersion = "5.3.3";
  version = "${finalAttrs.repoVersion}-${finalAttrs.rocmVersion}";

  outputs = [
    "out"
  ] ++ lib.optionals buildTests [
    "test"
  ] ++ lib.optionals buildSamples [
    "sample"
  ] ++ lib.optionals buildDocs [
    "docs"
  ];

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocWMMA";
    rev = "rocm-${finalAttrs.rocmVersion}";
    hash = "sha256-wU3R1XGTy7uFbceUyE0wy+XayicuyJIVfd1ih6pbTN0=";
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
    python3Packages.sphinx_rtd_theme
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
  ] ++ lib.optionals (gpuTargets != null) [
    "-DGPU_TARGETS=${lib.strings.concatStringsSep ";" gpuTargets}"
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

  postInstall = lib.optionalString buildTests ''
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

  postFixup = lib.optionalString buildDocs ''
    mkdir -p $docs/share/doc/rocwmma
    mv ../docs/source/_build/html $docs/share/doc/rocwmma
    mv ../docs/source/_build/latex/rocWMMA.pdf $docs/share/doc/rocwmma
  '';

  passthru.updateScript = writeScript "update.sh" ''
    #!/usr/bin/env nix-shell
    #!nix-shell -i bash -p curl jq common-updater-scripts
    json="$(curl -sL "https://api.github.com/repos/ROCmSoftwarePlatform/rocWMMA/releases?per_page=1")"
    repoVersion="$(echo "$json" | jq '.[0].name | split(" ") | .[1]' --raw-output)"
    rocmVersion="$(echo "$json" | jq '.[0].tag_name | split("-") | .[1]' --raw-output)"
    update-source-version rocwmma "$repoVersion" --ignore-same-hash --version-key=repoVersion
    update-source-version rocwmma "$rocmVersion" --ignore-same-hash --version-key=rocmVersion
  '';

  meta = with lib; {
    description = "Mixed precision matrix multiplication and accumulation";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocWMMA";
    license = with licenses; [ mit ];
    maintainers = teams.rocm.members;
    broken = finalAttrs.rocmVersion != hip.version;
  };
})
