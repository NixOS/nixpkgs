{ lib, buildPythonPackage, fetchFromGitHub, python, isPy3k }:

buildPythonPackage rec {
  pname = "jieba";
  version = "0.39";

  # no tests in PyPI tarball
  src = fetchFromGitHub {
    owner = "fxsjy";
    repo = pname;
    rev = "v${version}";
    sha256 = "0hbq0l1jbgcvm58qg4p37im4jl5a9igvq3wlhlk22pmbkbvqqgzs";
  };

  checkInputs = [  ];

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
    homepage = https://github.com/fxsjy/jieba;
    license = licenses.mit;
  };
}
