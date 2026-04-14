{
  lib,
  stdenv,
  addBinToPathHook,
  antlr4_13,
  booleanoperations,
  buildPythonPackage,
  cmake,
  cython,
  defcon,
  fetchFromGitHub,
  fontmath,
  fonttools,
  libxml2,
  lxml,
  mypy,
  ninja,
  pytestCheckHook,
  runAllTests ? false,
  scikit-build-core,
  setuptools-scm,
  tqdm,
  ufonormalizer,
  ufoprocessor,
  uharfbuzz,

  # passthru
  afdko,
}:

buildPythonPackage (finalAttrs: {
  pname = "afdko";
  version = "5.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adobe-type-tools";
    repo = "afdko";
    tag = finalAttrs.version;
    hash = "sha256:sha256-ts7vFfbPPrdooOH0JYrn3YKs7kRju4LbZ8Ypd3ExELc=";
  };

  postPatch = ''
    # https://github.com/NixOS/nixpkgs/pull/510112#issuecomment-4263642029
    substituteInPlace CMakeLists.txt \
      --replace-fail 'cmake_minimum_required(VERSION 3.16)' "cmake_minimum_required(VERSION 3.16)
    find_package(LibXml2 REQUIRED)"
  '';

  build-system = [
    cmake
    cython
    ninja
    scikit-build-core
    setuptools-scm
  ];

  cmakeFlags = [
    "-DANTLR4_INCLUDE_DIRS=${lib.getDev antlr4_13.runtime.cpp}/include/antlr4-runtime"
  ];

  buildInputs = [
    antlr4_13.runtime.cpp
    libxml2.dev
  ];

  patches = [
    ./dont-fetch-third-party-libs.patch

    # Use antlr4 runtime from nixpkgs and link it dynamically
    ./use-dynamic-system-antlr4-runtime.patch
  ];

  env = {
    FORCE_SYSTEM_ANTLR4 = true;
    # Use system libxml2
    FORCE_SYSTEM_LIBXML2 = true;
  };

  dontUseCmakeConfigure = true;

  dependencies = [
    booleanoperations
    defcon
    fontmath
    fonttools
    lxml
    tqdm
    ufonormalizer
    ufoprocessor
  ]
  ++ defcon.optional-dependencies.lxml
  ++ defcon.optional-dependencies.pens
  ++ fonttools.optional-dependencies.lxml
  ++ fonttools.optional-dependencies.ufo
  ++ fonttools.optional-dependencies.unicode
  ++ fonttools.optional-dependencies.woff;

  nativeCheckInputs = [
    addBinToPathHook
    mypy
    pytestCheckHook
    uharfbuzz
  ];

  disabledTests = [
    "test_output_file_option"
    "test_remove_overlap_otf"
    "test_remove_overlap_type1_cff"
    "test_remove_overlap_ufo"
    "test_sparse_mmotf"
    "test_ufo3_masters"
    # broke in the fontforge 4.51 -> 4.53 update
    "test_glyphs_2_7"
    "test_hinting_data"
    "test_waterfallplot"
    # broke at some point
    "test_type1_supported_hint"
  ]
  ++ lib.optionals (stdenv.cc.isGNU) [
    # broke in the gcc 13 -> 14 update
    "test_dump"
    "test_input_formats"
    "test_other_input_formats"
  ]
  ++ lib.optionals (!runAllTests) [
    # Disable slow tests, reduces test time ~25 %
    "test_report"
    "test_post_overflow"
    "test_cjk"
    "test_extrapolate"
    "test_filename_without_dir"
    "test_overwrite"
    "test_options"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isAarch || stdenv.hostPlatform.isRiscV) [
    # unknown reason so far
    # https://github.com/adobe-type-tools/afdko/issues/1425
    "test_spec"
  ]
  ++ lib.optionals (stdenv.hostPlatform.isi686) [
    "test_dump_option"
    "test_type1mm_inputs"
  ];

  passthru.tests = {
    fullTestsuite = afdko.override { runAllTests = true; };
  };

  meta = {
    description = "Adobe Font Development Kit for OpenType";
    changelog = "https://github.com/adobe-type-tools/afdko/blob/${finalAttrs.version}/NEWS.md";
    homepage = "https://adobe-type-tools.github.io/afdko";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
})
