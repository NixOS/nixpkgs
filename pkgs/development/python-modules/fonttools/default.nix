{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  isPyPy,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  fs,
  lxml,
  brotli,
  brotlicffi,
  zopfli,
  unicodedata2,
  lz4,
  scipy,
  munkres,
  pycairo,
  matplotlib,
  sympy,
  xattr,
  skia-pathops,
  uharfbuzz,
  pytest7CheckHook,
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "4.54.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "fonttools";
    rev = "refs/tags/${version}";
    hash = "sha256-iYd3EiziaLR7zS0UQAje0QfShNfnhHPdH2+noCQ2yto=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies =
    let
      extras = {
        ufo = [ fs ];
        lxml = [ lxml ];
        woff = [
          (if isPyPy then brotlicffi else brotli)
          zopfli
        ];
        unicode = lib.optional (pythonOlder "3.11") unicodedata2;
        graphite = [ lz4 ];
        interpolatable = [
          pycairo
          (if isPyPy then munkres else scipy)
        ];
        plot = [ matplotlib ];
        symfont = [ sympy ];
        type1 = lib.optional stdenv.hostPlatform.isDarwin xattr;
        pathops = [ skia-pathops ];
        repacker = [ uharfbuzz ];
      };
    in
    extras // { all = lib.concatLists (lib.attrValues extras); };

  nativeCheckInputs =
    [
      # test suite fails with pytest>=8.0.1
      # https://github.com/fonttools/fonttools/issues/3458
      pytest7CheckHook
    ]
    ++ lib.concatLists (
      lib.attrVals (
        [
          "woff"
          # "interpolatable" is not included because it only contains 2 tests at the time of writing but adds 270 extra dependencies
          "ufo"
        ]
        ++ lib.optionals (!skia-pathops.meta.broken) [
          "pathops" # broken
        ]
        ++ [ "repacker" ]
      ) optional-dependencies
    );

  pythonImportsCheck = [ "fontTools" ];

  preCheck = ''
    # tests want to execute the "fonttools" executable from $PATH
    export PATH="$out/bin:$PATH"
  '';

  # Timestamp tests have timing issues probably related
  # to our file timestamp normalization
  disabledTests = [
    "test_recalc_timestamp_ttf"
    "test_recalc_timestamp_otf"
    "test_ttcompile_timestamp_calcs"
  ];

  disabledTestPaths = [
    # avoid test which depend on fs and matplotlib
    # fs and matplotlib were removed to prevent strong cyclic dependencies
    "Tests/misc/plistlib_test.py"
    "Tests/pens"
    "Tests/ufoLib"

    # test suite fails with pytest>=8.0.1
    # https://github.com/fonttools/fonttools/issues/3458
    "Tests/ttLib/woff2_test.py"
    "Tests/ttx/ttx_test.py"
  ];

  meta = with lib; {
    homepage = "https://github.com/fonttools/fonttools";
    description = "Library to manipulate font files from Python";
    changelog = "https://github.com/fonttools/fonttools/blob/${version}/NEWS.rst";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
