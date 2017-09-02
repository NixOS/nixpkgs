{ lib, fetchFromGitHub, buildPythonPackage, pillow, six
, tesseract, cuneiform
}:

buildPythonPackage rec {
  name = "pyocr-${version}";
  version = "0.4.6";

  # Don't fetch from PYPI because it doesn't contain tests.
  src = fetchFromGitHub {
    owner = "jflesch";
    repo = "pyocr";
    rev = version;
    sha256 = "0amyhkkm400qzbw65ivyzrzxl2r7vxqgsgqm7ml95m7gwkwhnzz0";
  };

  patches = [ ./tesseract.patch ];

  postPatch = ''
    sed -i \
      -e 's,^\(TESSERACT_CMD *= *\).*,\1"${tesseract}/bin/tesseract",' \
      -e 's,^\(CUNEIFORM_CMD *= *\).*,\1"${cuneiform}/bin/cuneiform",' \
      -e '/^CUNIFORM_POSSIBLE_PATHS *= *\[/,/^\]$/ {
        c CUNIFORM_POSSIBLE_PATHS = ["${cuneiform}/share/cuneiform"]
      }' src/pyocr/{tesseract,cuneiform}.py

    sed -i -r \
      -e 's,"libtesseract\.so\.3","${tesseract}/lib/libtesseract.so",' \
      -e 's,^(TESSDATA_PREFIX *=).*,\1 "${tesseract}/share/tessdata",' \
      src/pyocr/libtesseract/tesseract_raw.py

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
