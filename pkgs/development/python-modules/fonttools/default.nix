{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, brotlipy
, zopfli
, lxml
, scipy
, munkres
, unicodedata2
, sympy
, reportlab
, sphinx
, pytestCheckHook
, glibcLocales
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "4.29.0";

  # Bump to 3.7 when https://github.com/fonttools/fonttools/pull/2417 is merged
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = version;
    sha256 = "LnkpTEpZbbRAyqGPJXdfpHjh4t7n6LkjZGLhirVNl7E=";
  };

  # all dependencies are optional, but
  # we run the checks with them

  checkInputs = [
    pytestCheckHook
    # etree extra
    lxml
    # woff extra
    brotlipy
    zopfli
    # interpolatable extra
    scipy
    munkres
    # symfont
    sympy
    # pens
    reportlab
    sphinx
  ] ++ lib.optionals (pythonOlder "3.9") [
    # unicode extra
    unicodedata2
  ];

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
