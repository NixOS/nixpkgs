{
  lib,
  stdenv,
  # Enables some expensive tests, useful for verifying an update
  afdko,
  antlr4_9,
  booleanoperations,
  buildPythonPackage,
  cmake,
  defcon,
  fetchFromGitHub,
  fontmath,
  fontpens,
  fonttools,
  libxml2,
  mutatormath,
  ninja,
  pytestCheckHook,
  pythonOlder,
  runAllTests ? false,
  scikit-build,
  setuptools-scm,
  tqdm,
  ufonormalizer,
  ufoprocessor,
}:

buildPythonPackage rec {
  pname = "afdko";
  version = "4.0.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "adobe-type-tools";
    repo = "afdko";
    rev = "refs/tags/${version}";
    hash = "sha256-I5GKPkbyQX8QNSZgNB3wPKdWwpx8Xkklesu1M7nhgp8=";
  };

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [
    scikit-build
    cmake
    ninja
  ];

  buildInputs = [
    antlr4_9.runtime.cpp
    libxml2.dev
  ];

  patches = [
    # Don't try to install cmake and ninja using pip
    ./no-pypi-build-tools.patch

    # Use antlr4 runtime from nixpkgs and link it dynamically
    ./use-dynamic-system-antlr4-runtime.patch
  ];

  # Happy new year
  postPatch = ''
    substituteInPlace tests/tx_data/expected_output/alt-missing-glif.pfb --replace 2023 2024
  '';

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang (toString [
    "-Wno-error=incompatible-function-pointer-types"
    "-Wno-error=int-conversion"
  ]);

  # setup.py will always (re-)execute cmake in buildPhase
  dontConfigure = true;

  dependencies =
    [
      booleanoperations
      defcon
      fontmath
      fontpens
      fonttools
      mutatormath
      tqdm
      ufonormalizer
      ufoprocessor
    ]
    ++ defcon.optional-dependencies.lxml
    ++ fonttools.optional-dependencies.lxml
    ++ fonttools.optional-dependencies.ufo
    ++ fonttools.optional-dependencies.unicode
    ++ fonttools.optional-dependencies.woff;

  # Use system libxml2
  FORCE_SYSTEM_LIBXML2 = true;

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export PATH=$PATH:$out/bin

    # Remove build artifacts to prevent them from messing with the tests
    rm -rf _skbuild
  '';

  disabledTests =
    [
      # broke in the fontforge 4.51 -> 4.53 update
      "test_glyphs_2_7"
      "test_hinting_data"
      "test_waterfallplot"
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

  meta = with lib; {
    description = "Adobe Font Development Kit for OpenType";
    changelog = "https://github.com/adobe-type-tools/afdko/blob/${version}/NEWS.md";
    homepage = "https://adobe-type-tools.github.io/afdko";
    license = licenses.asl20;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
