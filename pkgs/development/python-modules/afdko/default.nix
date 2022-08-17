{ lib, stdenv, buildPythonPackage, fetchPypi, fetchpatch, pythonOlder
, fonttools, defcon, lxml, fs, unicodedata2, zopfli, brotlipy, fontpens
, brotli, fontmath, mutatormath, booleanoperations
, ufoprocessor, ufonormalizer, psautohint, tqdm
, setuptools-scm, scikit-build
, cmake
, antlr4_9
, libxml2
, pytestCheckHook
# Enables some expensive tests, useful for verifying an update
, runAllTests ? false
, afdko
}:

buildPythonPackage rec {
  pname = "afdko";
  version = "3.9.0";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1fjsaz6bp028fbmry6fzfcih78mdzycqmky1wsz5y0bg4kfk4shh";
  };

  format = "pyproject";

  nativeBuildInputs = [
    setuptools-scm
    scikit-build
    cmake
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

    ./libxml2-cmake-find-package.patch
  ];

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

  checkInputs = [ pytestCheckHook ];
  preCheck = ''
    export PATH=$PATH:$out/bin

    # Update tests to match ufinormalizer-0.6.1 expectations:
    #   https://github.com/adobe-type-tools/afdko/issues/1418
    find tests -name layerinfo.plist -delete
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
    "test_type1mm_inputs"
  ];

  passthru.tests = {
    fullTestsuite = afdko.override { runAllTests = true; };
  };

  meta = with lib; {
    description = "Adobe Font Development Kit for OpenType";
    homepage = "https://adobe-type-tools.github.io/afdko/";
    license = licenses.asl20;
    maintainers = [ maintainers.sternenseemann ];
  };
}
