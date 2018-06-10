{ lib, fetchFromGitHub, buildPythonPackage, pillow, six
, tesseract, cuneiform, isPy3k
}:

buildPythonPackage rec {
  pname = "pyocr";
  version = "0.4.7";
  name = pname + "-" + version;
  disabled = !isPy3k;

  # Don't fetch from PYPI because it doesn't contain tests.
  src = fetchFromGitHub {
    owner = "jflesch";
    repo = "pyocr";
    rev = version;
    sha256 = "1iw73r8yrgjf8g00yzpz62ymqbf89cqhyhl9g430srmsrq7mn2yd";
  };

  NIX_CUNEIFORM_CMD = "${cuneiform}/bin/cuneiform";
  NIX_CUNEIFORM_DATA = "${cuneiform}/share/cuneiform";
  NIX_LIBTESSERACT_PATH = "${tesseract}/lib/libtesseract.so";
  NIX_TESSDATA_PREFIX = "${tesseract}/share/tessdata";
  NIX_TESSERACT_CMD = "${tesseract}/bin/tesseract";

  patches = [ ./paths.patch ];

  postPatch = ''
    substituteInPlace src/pyocr/cuneiform.py \
      --subst-var NIX_CUNEIFORM_CMD \
      --subst-var NIX_CUNEIFORM_CMD

    substituteInPlace src/pyocr/tesseract.py \
      --subst-var NIX_TESSERACT_CMD

    substituteInPlace src/pyocr/libtesseract/tesseract_raw.py \
      --subst-var NIX_TESSDATA_PREFIX \
      --subst-var NIX_LIBTESSERACT_PATH

    # Disable specific tests that are probably failing because of this issue:
    # https://github.com/jflesch/pyocr/issues/52
    for test in $disabledTests; do
      file="''${test%%:*}"
      fun="''${test#*:}"
      echo "$fun = unittest.skip($fun)" >> "tests/tests_$file.py"
    done
  '';

  disabledTests = [
    "cuneiform:TestTxt.test_basic"
    "cuneiform:TestTxt.test_european"
    "cuneiform:TestTxt.test_french"
    "cuneiform:TestWordBox.test_basic"
    "cuneiform:TestWordBox.test_european"
    "cuneiform:TestWordBox.test_french"
    "libtesseract:TestBasicDoc.test_basic"
    "libtesseract:TestDigitLineBox.test_digits"
    "libtesseract:TestLineBox.test_japanese"
    "libtesseract:TestTxt.test_japanese"
    "libtesseract:TestWordBox.test_japanese"
    "tesseract:TestDigitLineBox.test_digits"
    "tesseract:TestTxt.test_japanese"
  ];

  propagatedBuildInputs = [ pillow six ];

  meta = {
    homepage = "https://github.com/jflesch/pyocr";
    description = "A Python wrapper for Tesseract and Cuneiform";
    license = lib.licenses.gpl3Plus;
  };
}
