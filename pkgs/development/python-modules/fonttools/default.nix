{
  lib,
  stdenv,
  buildPythonPackage,
  pythonOlder,
  isPyPy,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
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
  addBinToPathHook,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "fonttools";
  version = "4.63.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "fonttools";
    tag = finalAttrs.version;
    hash = "sha256-XTE18TKpIa4MpbJ5tcHwCyLk3Q6CV/ElzMtddG86HJA=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  optional-dependencies =
    let
      extras = {
        ufo = [ ];
        lxml = [ lxml ];
        woff = [
          (if isPyPy then brotlicffi else brotli)
          zopfli
        ];
        unicode = lib.optional (pythonOlder "3.15") unicodedata2;
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

  nativeCheckInputs = [
    addBinToPathHook
    pytestCheckHook
  ]
  ++ lib.concatLists (
    lib.attrVals (
      [
        "woff"
        # "interpolatable" is not included because it only contains 2 tests at the time of writing but adds 270 extra dependencies
        "ufo"
      ]
      ++
        lib.optionals (lib.meta.availableOn stdenv.hostPlatform skia-pathops && !skia-pathops.meta.broken)
          [
            "pathops" # broken
          ]
      ++ [ "repacker" ]
    ) finalAttrs.passthru.optional-dependencies
  );

  pythonImportsCheck = [ "fontTools" ];

  # Timestamp tests have timing issues probably related
  # to our file timestamp normalization
  disabledTests = [
    "test_recalc_timestamp_ttf"
    "test_recalc_timestamp_otf"
    "test_ttcompile_timestamp_calcs"
  ];

  meta = {
    homepage = "https://github.com/fonttools/fonttools";
    description = "Library to manipulate font files from Python";
    changelog = "https://github.com/fonttools/fonttools/blob/${finalAttrs.src.tag}/NEWS.rst";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.sternenseemann ];
  };
})
