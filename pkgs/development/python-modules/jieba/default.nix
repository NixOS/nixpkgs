{ lib, buildPythonPackage, fetchFromGitHub, glibcLocales, python, isPy3k }:

buildPythonPackage rec {
  pname = "jieba";
  version = "0.40";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "fxsjy";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nasyxva9m3k9fb9g627ppphp3697jdplbb2bavqx71sa7mqim2m";
  };

  checkInputs = [ glibcLocales ];

  # UnicodeEncodeError
  doCheck = isPy3k;

  # Citing https://github.com/fxsjy/jieba/issues/384: "testcases is in a mess"
  # So just picking random ones that currently work
  checkPhase = ''
    export LC_ALL=en_US.UTF-8
    ${python.interpreter} test/test.py
    ${python.interpreter} test/test_tokenize.py
  '';

  meta = with lib; {
    description = "Chinese Words Segementation Utilities";
    homepage = https://github.com/fxsjy/jieba;
    license = licenses.mit;
  };
}
