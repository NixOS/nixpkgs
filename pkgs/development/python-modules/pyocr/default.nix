{ lib, fetchFromGitLab, buildPythonPackage, pillow, six
, tesseract, cuneiform, isPy3k, substituteAll, pytest, tox
}:

buildPythonPackage rec {
  pname = "pyocr";
  version = "0.5.3";
  disabled = !isPy3k;

  # Don't fetch from PYPI because it doesn't contain tests.
  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    group = "World";
    owner = "OpenPaperwork";
    repo = "pyocr";
    rev = version;
    sha256 = "1nihf0qmbpg3yj3yp11jp6hp5z5dqf39nz6j9lqbvgi1nqbs7x15";
  };

  patches = [ (substituteAll {
    src = ./paths.patch;
    inherit cuneiform tesseract;
  })
  ];

  postPatch = ''
    echo 'version = "${version}"' > src/pyocr/_version.py

    # Disable specific tests that are probably failing because of this issue:
    # https://github.com/jflesch/pyocr/issues/52
    for test in $disabledTests; do
      file="''${test%%:*}"
      fun="''${test#*:}"
      echo "import pytest" >> "tests/tests_$file.py"
      echo "$fun = pytest.mark.skip($fun)" >> "tests/tests_$file.py"
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
    "libtesseract:TestTxt.test_multi"
    "tesseract:TestTxt.test_multi"
    "tesseract:TestDigitLineBox.test_digits"
    "tesseract:TestTxt.test_japanese"
  ];

  propagatedBuildInputs = [ pillow six ];
  checkInputs = [ pytest tox ];
  checkPhase = "pytest";

  meta = {
    inherit (src.meta) homepage;
    description = "A Python wrapper for Tesseract and Cuneiform";
    license = lib.licenses.gpl3Plus;
  };
}
