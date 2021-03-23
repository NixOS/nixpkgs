{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, brotlipy
, zopfli
, fs
, lxml
, scipy
, munkres
, unicodedata2
, sympy
, matplotlib
, reportlab
, sphinx
, pytest
, pytest-randomly
, glibcLocales
}:

buildPythonPackage rec {
  pname = "fonttools";
  version = "4.21.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner  = pname;
    repo   = pname;
    rev    = version;
    sha256 = "1x9qrg6ppqhm5214ymwvn0r34qdz8pqvyxd0sj7rkp06wa757z2i";
  };

  # all dependencies are optional, but
  # we run the checks with them
  checkInputs = [
    pytest
    pytest-randomly
    glibcLocales
    # etree extra
    lxml
    # ufo extra
    fs
    # woff extra
    brotlipy
    zopfli
    # unicode extra
    unicodedata2
    # interpolatable extra
    scipy
    munkres
    # symfont
    sympy
    # varLib
    matplotlib
    # pens
    reportlab
    sphinx
  ];

  preCheck = ''
    export LC_ALL="en_US.UTF-8"
  '';

  # avoid timing issues with timestamps in subset_test.py and ttx_test.py
  checkPhase = ''
    pytest Tests fontTools \
      -k 'not ttcompile_timestamp_calcs and not recalc_timestamp'
  '';

  meta = with lib; {
    homepage = "https://github.com/fonttools/fonttools";
    description = "A library to manipulate font files from Python";
    license = licenses.mit;
    maintainers = [ maintainers.sternenseemann ];
  };
}
