{
  lib,
  buildPythonPackage,
  fetchFromGitea,
  flake8,
  click,
  pyyaml,
  six,
  pytestCheckHook,
  pytest-cov-stub,
}:

buildPythonPackage rec {
  pname = "clickclick";
  version = "20.10.2";
  format = "setuptools";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "hjacobs";
    repo = "python-clickclick";
    rev = version;
    hash = "sha256-gefU6CI4ibtvonsaKZmuffuUNUioBn5ODs72BI5zXOw=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
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
