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
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "4.60.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "fonttools";
    repo = "fonttools";
    tag = version;
    hash = "sha256-h/JRItD5IHlhNSamxRxk/dvyAKUFayzxHvlW7v4N1s8=";
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
        unicode = lib.optional (pythonOlder "3.13") unicodedata2;
        graphite = [ lz4 ];
        interpolatable = [
          pycairo
          (if isPyPy then munkres else scipy)
        ];
        plot = [ matplotlib ];
        symfont = [ sympy ];
        type1 = lib.optional stdenv.hostPlatform.isDarwin xattr;
        pathops = lib.optional (lib.meta.availableOn stdenv.hostPlatform skia-pathops) skia-pathops;
        repacker = [ uharfbuzz ];
      };
    in
    extras // { all = lib.concatLists (lib.attrValues extras); };

  nativeCheckInputs = [
    pytestCheckHook
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

  meta = with lib; {
    homepage = "https://github.com/fonttools/fonttools";
    description = "Library to manipulate font files from Python";
    changelog = "https://github.com/fonttools/fonttools/blob/${src.tag}/NEWS.rst";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
