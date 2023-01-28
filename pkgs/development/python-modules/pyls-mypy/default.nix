{ lib, buildPythonPackage, fetchFromGitHub, isPy27
, future, python-language-server, mypy, configparser
, pytestCheckHook, mock, pytest-cov, coverage
, fetchpatch
}:

buildPythonPackage rec {
  pname = "pyls-mypy";
  version = "0.1.8";

  src = fetchFromGitHub {
    owner = "tomv564";
    repo = "pyls-mypy";
    rev = version;
    sha256 = "14giyvcrq4w3asm1nyablw70zkakkcsr76chk5a41alxlk4l2alb";
  };

  # presumably tests don't find typehints ?
  doCheck = false;

  disabledTests = [
    "test_parse_line_without_line"
  ];

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  patches = [
    # makes future optional
    (fetchpatch {
      url = "https://github.com/tomv564/pyls-mypy/commit/2949582ff5f39b1de51eacc92de6cfacf1b5ab75.patch";
      sha256 = "0bqkvdy5mxyi46nhq5ryynf465f68b6ffy84hmhxrigkapz085g5";
    })
  ];

  nativeCheckInputs = [ mock pytest-cov coverage pytestCheckHook ];

  propagatedBuildInputs = [
    mypy python-language-server configparser
  ] ++ lib.optionals (isPy27) [
    future
  ];

  meta = with lib; {
    homepage = "https://github.com/tomv564/pyls-mypy";
    description = "Mypy plugin for the Python Language Server";
    license = licenses.mit;
    maintainers = [ ];
  };
}
