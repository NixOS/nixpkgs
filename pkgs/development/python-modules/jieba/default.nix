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
    hash = "sha256-s/PsH8DbEWl055C21z612kd/aXX4cBoDTZYbqU2rGwk=";
  };

  # UnicodeEncodeError
  doCheck = isPy3k;

  # Citing https://github.com/fxsjy/jieba/issues/384: "testcases is in a mess"
  # So just picking random ones that currently work
  checkPhase = ''
    ${python.interpreter} test/test.py
    ${python.interpreter} test/test_tokenize.py
  '';

  meta = {
    description = "Chinese Words Segmentation Utilities";
    homepage = "https://github.com/fxsjy/jieba";
    license = lib.licenses.mit;
    teams = [ lib.teams.tts ];
  };
}
