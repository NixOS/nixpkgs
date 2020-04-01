{ lib, buildPythonPackage, fetchFromGitHub, glibcLocales, python, isPy3k }:

buildPythonPackage rec {
  pname = "jieba";
  version = "0.42.1";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "fxsjy";
    repo = pname;
    rev = "v${version}";
    sha256 = "028vmd6sj6wn9l1ilw7qfmlpyiysnlzdgdlhwxs6j4fvq0gyrwxk";
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
