{ lib, buildPythonPackage, fetchFromGitHub, isPy3k, pythonOlder
, snowballstemmer, six, configparser
, pytest, pytestpep8, mock, pathlib }:

buildPythonPackage rec {
  pname = "pydocstyle";
  version = "2.1.1";

  # no tests on PyPI
  # https://github.com/PyCQA/pydocstyle/issues/302
  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = pname;
    rev = version;
    sha256 = "1h0k8lpx14svc8dini62j0kqiam10pck5sdzvxa4xhsx7y689g5l";
  };

  propagatedBuildInputs = [ snowballstemmer six ] ++ lib.optional (!isPy3k) configparser;

  checkInputs = [ pytest pytestpep8 mock ] ++ lib.optional (pythonOlder "3.4") pathlib;

  checkPhase = ''
    # test_integration.py installs packages via pip
    py.test --pep8 --cache-clear -vv src/tests -k "not test_integration"
  '';

  meta = with lib; {
    description = "Python docstring style checker";
    homepage = https://github.com/PyCQA/pydocstyle/;
    license = licenses.mit;
    maintainers = with maintainers; [ dzabraev ];
  };
}
