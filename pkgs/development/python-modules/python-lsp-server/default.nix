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
  version = "1.2.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "python-lsp";
    repo = pname;
    rev = "v${version}";
    sha256 = "09wnnbf7lqqni6xkpzzk7nmcqjm5bx49xqzmp5fkb9jk50ivcrdz";
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
