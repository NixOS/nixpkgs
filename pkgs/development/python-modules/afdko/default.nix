{
  lib,
  stdenv,
  antlr4_13,
  booleanoperations,
  buildPythonPackage,
  cmake,
  defcon,
  fetchFromGitHub,
  fetchpatch,
  fontmath,
  fontpens,
  fonttools,
  libxml2,
  mutatormath,
  ninja,
  pytestCheckHook,
  runAllTests ? false,
  scikit-build,
  setuptools-scm,
  tqdm,
  ufonormalizer,
  ufoprocessor,

  # passthru
  afdko,
}:

buildPythonPackage (finalAttrs: {
  pname = "afdko";
  version = "4.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "adobe-type-tools";
    repo = "afdko";
    tag = finalAttrs.version;
    hash = "sha256:0955dvbydifhgx9gswbf5drsmmghry7iyf6jwz6qczhj86clswcm";
  };

  build-system = [ setuptools-scm ];

  nativeBuildInputs = [
    scikit-build
    cmake
    ninja
  ];

  buildInputs = [
    antlr4_13.runtime.cpp
    libxml2.dev
  ];

  patches = [
    # Don't try to install cmake and ninja using pip
    ./no-pypi-build-tools.patch

    # Use antlr4 runtime from nixpkgs and link it dynamically
    ./use-dynamic-system-antlr4-runtime.patch

    # Fix tests
    # FIXME: remove in 5.0
    (fetchpatch {
      url = "https://github.com/adobe-type-tools/afdko/commit/3b78bea15245e2bd2417c25ba5c2b8b15b07793c.patch";
      excludes = [
        "CMakeLists.txt"
        "requirements.txt"
      ];
      hash = "sha256-Ao5AUVm1h4a3qidqlBFWdC7jiXyBfXQEnsT7XsXXXRU=";
    })
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang (toString [
    "-Wno-error=incompatible-function-pointer-types"
    "-Wno-error=int-conversion"
  ]);

  # setup.py will always (re-)execute cmake in buildPhase
  dontConfigure = true;

  dependencies = [
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

  disabledTests = [
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
