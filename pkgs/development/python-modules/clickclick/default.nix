{ stdenv, lib, buildPythonPackage, fetchFromGitHub, isPy36, flake8, click, pyyaml, six, pytestCheckHook, pytestcov }:

buildPythonPackage rec {
  pname = "clickclick";
  version = "1.2.2";

  src = fetchFromGitHub {
    owner = "hjacobs";
    repo = "python-clickclick";
    rev = version;
    sha256 = "1rij9ws9nhsmagiy1vclzliiqfkxi006rf65qvrw1k3sm2s8p5g0";
  };

  checkInputs = [ pytestCheckHook pytestcov ];
  propagatedBuildInputs = [ flake8 click pyyaml six ];

  disabledTests = lib.optionals isPy36 [
    "test_cli"
    "test_choice_default"
  ];

  meta = with stdenv.lib; {
    description = "Click command line utilities";
    homepage = https://github.com/hjacobs/python-clickclick/;
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
