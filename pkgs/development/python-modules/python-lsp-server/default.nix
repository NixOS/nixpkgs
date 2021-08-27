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
, withAutopep8 ? true
, withFlake8 ? true
, withMccabe ? true
, withPycodestyle ? true
, withPydocstyle ? true
, withPyflakes ? true
, withPylint ? true
, withRope ? true
, withYapf ? true
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
    jedi
    pluggy
    python-lsp-jsonrpc
    setuptools
    ujson
  ] ++ lib.optional withAutopep8 autopep8
    ++ lib.optional withFlake8 flake8
    ++ lib.optional withMccabe mccabe
    ++ lib.optional withPycodestyle pycodestyle
    ++ lib.optional withPydocstyle pydocstyle
    ++ lib.optional withPyflakes pyflakes
    ++ lib.optional withPylint pylint
    ++ lib.optional withRope rope
    ++ lib.optional withYapf yapf;

  checkInputs = [
    flaky
    matplotlib
    numpy
    pandas
    pyqt5
    pytestCheckHook
  ];

  disabledTests = lib.optional (!withPycodestyle) "test_workspace_loads_pycodestyle_config";

  disabledTestPaths = lib.optional (!withAutopep8) "test/plugins/test_autopep8_format.py"
    ++ lib.optional (!withRope) "test/plugins/test_completion.py"
    ++ lib.optional (!withFlake8) "test/plugins/test_flake8_lint.py"
    ++ lib.optional (!withMccabe) "test/plugins/test_mccabe_lint.py"
    ++ lib.optional (!withPycodestyle) "test/plugins/test_pycodestyle_lint.py"
    ++ lib.optional (!withPydocstyle) "test/plugins/test_pydocstyle_lint.py"
    ++ lib.optional (!withPyflakes) "test/plugins/test_pyflakes_lint.py"
    ++ lib.optional (!withPylint) "test/plugins/test_pylint_lint.py"
    ++ lib.optional (!withRope) "test/plugins/test_rope_rename.py"
    ++ lib.optional (!withYapf) "test/plugins/test_yapf_format.py";

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
