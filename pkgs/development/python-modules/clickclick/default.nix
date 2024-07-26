{ lib, buildPythonPackage, fetchFromGitHub, flake8, click, pyyaml, six, pytestCheckHook, pytest-cov }:

buildPythonPackage rec {
  pname = "clickclick";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hjacobs";
    repo = "python-clickclick";
    rev = version;
    sha256 = "1rij9ws9nhsmagiy1vclzliiqfkxi006rf65qvrw1k3sm2s8p5g0";
  };

  nativeCheckInputs = [ pytestCheckHook pytest-cov ];
  propagatedBuildInputs = [ flake8 click pyyaml six ];

  # test_cli asserts on exact quoting style of output
  disabledTests = [
    "test_cli"
  ];

  meta = with lib; {
    description = "Click command line utilities";
    homepage = "https://github.com/hjacobs/python-clickclick/";
    license = licenses.asl20;
    maintainers = with maintainers; [ elohmeier ];
  };
}
