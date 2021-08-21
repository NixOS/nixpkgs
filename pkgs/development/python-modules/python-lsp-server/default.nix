{ lib
, autopep8
, buildPythonPackage
, fetchFromGitHub
, flake8
, flaky
, jedi
, matplotlib
, mccabe
, numpy
, pandas
, pluggy
, pycodestyle
, pydocstyle
, pyflakes
, pylint
, pyqt5
, pytestCheckHook
, python-lsp-jsonrpc
, pythonOlder
, rope
, setuptools
, ujson
, yapf
}:

buildPythonPackage rec {
  pname = "python-lsp-server";
  version = "1.2.1";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-TyXKlXeXMyq+bQq9ngDm0SuW+rAhDlOVlC3mDI1THwk=";
  };

  propagatedBuildInputs = [
    autopep8
    flake8
    jedi
    mccabe
    pluggy
    pycodestyle
    pydocstyle
    pyflakes
    pylint
    python-lsp-jsonrpc
    rope
    setuptools
    ujson
    yapf
  ];

  checkInputs = [
    flaky
    matplotlib
    numpy
    pandas
    pyqt5
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "--cov-report html --cov-report term --junitxml=pytest.xml" "" \
      --replace "--cov pylsp --cov test" ""
  '';

  preCheck = ''
    export HOME=$(mktemp -d);
  '';

  pythonImportsCheck = [ "pylsp" ];

  meta = with lib; {
    description = "Python implementation of the Language Server Protocol";
    homepage = "https://github.com/python-lsp/python-lsp-server";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
