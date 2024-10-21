{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  flake8,
  click,
  pyyaml,
  six,
  pytestCheckHook,
  pytest-cov,
}:

buildPythonPackage rec {
  pname = "clickclick";
  version = "1.2.2";
  format = "setuptools";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "hjacobs";
    repo = "python-clickclick";
    rev = version;
    sha256 = "1rij9ws9nhsmagiy1vclzliiqfkxi006rf65qvrw1k3sm2s8p5g0";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov
  ];
  propagatedBuildInputs = [
    flake8
    click
    pyyaml
    six
  ];

  # test_cli asserts on exact quoting style of output
  disabledTests = [ "test_cli" ];

  meta = with lib; {
    description = "Click command line utilities";
    homepage = "https://codeberg.org/hjacobs/python-clickclick/";
    license = licenses.asl20;
  };
}
