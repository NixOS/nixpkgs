{ lib
, stdenv
, buildPythonPackage
, pythonOlder
, isPyPy
, fetchFromGitHub
, setuptools-scm
, fs
, lxml
, brotli
, brotlicffi
, zopfli
, unicodedata2
, lz4
, scipy
, munkres
, matplotlib
, sympy
, xattr
, skia-pathops
, uharfbuzz
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "4.34.4";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev = "refs/tags/${version}";
    sha256 = "sha256-GwbcrDsfxs5qRQJozhK/+n3W3NlO39g7pzxL9iIiDfU=";
  };

  nativeBuildInputs = [ setuptools-scm ];

  passthru.optional-dependencies = let
    extras = {
      ufo = [ fs ];
      lxml = [ lxml ];
      woff = [ (if isPyPy then brotlicffi else brotli) zopfli ];
      unicode = lib.optional (pythonOlder "3.11") unicodedata2;
      graphite = [ lz4 ];
      interpolatable = [ (if isPyPy then munkres else scipy) ];
      plot = [ matplotlib ];
      symfont = [ sympy ];
      type1 = lib.optional stdenv.isDarwin xattr;
      pathops = [ skia-pathops ];
      repacker = [ uharfbuzz ];
    };
  in extras // {
    all = lib.concatLists (lib.attrValues extras);
  };

  checkInputs = [
    pytestCheckHook
  ] ++ lib.concatLists (lib.attrVals ([
    "woff"
    "interpolatable"
  ] ++ lib.optionals (!skia-pathops.meta.broken) [
    "pathops" # broken
  ] ++ [
    "repacker"
  ]) passthru.optional-dependencies);

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
  ];

  meta = with lib; {
    homepage = "https://github.com/fonttools/fonttools";
    description = "A library to manipulate font files from Python";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
