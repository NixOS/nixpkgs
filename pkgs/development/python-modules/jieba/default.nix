{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  python,
  isPy3k,
}:

buildPythonPackage rec {
  pname = "jieba";
  version = "0.42.1";
  format = "setuptools";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "fxsjy";
    repo = "jieba";
    rev = "v${version}";
    sha256 = "028vmd6sj6wn9l1ilw7qfmlpyiysnlzdgdlhwxs6j4fvq0gyrwxk";
  };

  # UnicodeEncodeError
  doCheck = isPy3k;

  # Citing https://github.com/fxsjy/jieba/issues/384: "testcases is in a mess"
  # So just picking random ones that currently work
  checkPhase = ''
    ${python.interpreter} test/test.py
    ${python.interpreter} test/test_tokenize.py
  '';

  meta = with lib; {
    description = "Chinese Words Segementation Utilities";
    homepage = "https://github.com/fxsjy/jieba";
    license = licenses.mit;
    teams = [ teams.tts ];
  };
}
