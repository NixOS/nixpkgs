{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, fonttools
, defcon
, lxml
, fs
, unicodedata2
, zopfli
, brotlipy
, fontpens
, brotli
, fontmath
, mutatormath
, booleanoperations
, ufoprocessor
, ufonormalizer
, psautohint
, tqdm
, setuptools-scm
, scikit-build
, cmake
, ninja
, antlr4_9
, libxml2
, pytestCheckHook
# Enables some expensive tests, useful for verifying an update
, runAllTests ? false
, afdko
}:

buildPythonPackage rec {
  pname = "afdko";
  version = "4.0.0+unstable-2023-11-07";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "adobe-type-tools";
    repo = pname;
    rev = "6c832edbd81ecf689dbe66e840bf18ae61cf4bca";
    hash = "sha256-XXkksHggUIs2O0/OSGsft8ofogcbtAa3w5JdldIAJAI=";
  };

  nativeBuildInputs = [
    setuptools-scm
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

  propagatedBuildInputs = [
    booleanoperations
    fonttools
    lxml           # fonttools[lxml], defcon[lxml] extra
    fs             # fonttools[ufo] extra
    unicodedata2   # fonttools[unicode] extra
    brotlipy       # fonttools[woff] extra
    zopfli         # fonttools[woff] extra
    fontpens
    brotli
    defcon
    fontmath
    mutatormath
    ufoprocessor
    ufonormalizer
    psautohint
    tqdm
  ];

  # Use system libxml2
  FORCE_SYSTEM_LIBXML2 = true;

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export PATH=$PATH:$out/bin

    # Remove build artifacts to prevent them from messing with the tests
    rm -rf _skbuild
  '';

  disabledTests = lib.optionals (!runAllTests) [
    # Disable slow tests, reduces test time ~25 %
    "test_report"
    "test_post_overflow"
    "test_cjk"
    "test_extrapolate"
    "test_filename_without_dir"
    "test_overwrite"
    "test_options"
  ] ++ lib.optionals (stdenv.hostPlatform.isAarch || stdenv.hostPlatform.isRiscV) [
    # unknown reason so far
    # https://github.com/adobe-type-tools/afdko/issues/1425
    "test_spec"
  ] ++ lib.optionals (stdenv.hostPlatform.isi686) [
    "test_dump_option"
    "test_type1mm_inputs"
  ];

  passthru.tests = {
    fullTestsuite = afdko.override { runAllTests = true; };
  };

  meta = with lib; {
    changelog = "https://github.com/adobe-type-tools/afdko/blob/${version}/NEWS.md";
    description = "Adobe Font Development Kit for OpenType";
    homepage = "https://adobe-type-tools.github.io/afdko";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
