{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder, isPy27
, backports_functools_lru_cache, configparser, futures, future, jedi, pluggy, python-jsonrpc-server, flake8
, pytestCheckHook, mock, pytestcov, coverage, setuptools, ujson
, # Allow building a limited set of providers, e.g. ["pycodestyle"].
  providers ? ["*"]
  # The following packages are optional and
  # can be overwritten with null as your liking.
, autopep8 ? null
, mccabe ? null
, pycodestyle ? null
, pydocstyle ? null
, pyflakes ? null
, pylint ? null
, rope ? null
, yapf ? null
}:

let
  withProvider = p: builtins.elem "*" providers || builtins.elem p providers;
in

buildPythonPackage rec {
  pname = "python-language-server";
  version = "0.33.1";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "python-language-server";
    rev = version;
    sha256 = "064ck4ikrrrhq8wjpbs5k6hzkrjvfg91pd6351471xpsij0kj16f";
  };

  postPatch = ''
    # https://github.com/palantir/python-jsonrpc-server/issues/36
    sed -i -e 's!ujson<=!ujson>=!' setup.py
  '';

  # The tests require all the providers, disable otherwise.
  doCheck = providers == ["*"];

  checkInputs = [
    pytestCheckHook mock pytestcov coverage
    # rope is technically a dependency, but we don't add it by default since we
    # already have jedi, which is the preferred option
    rope
  ];

  dontUseSetuptoolsCheck = true;

  preCheck = ''
    export HOME=$TEMPDIR
  '';

  # Tests failed since update to 0.31.8
  disabledTests = [
    "test_pyqt_completion"
    "test_numpy_completions"
    "test_pandas_completions"
    "test_matplotlib_completions"
    "test_snippet_parsing"
    "test_numpy_hover"
  ] ++ stdenv.lib.optional isPy27 "test_flake8_lint";

  propagatedBuildInputs = [ setuptools jedi pluggy future python-jsonrpc-server flake8 ujson ]
    ++ stdenv.lib.optional (withProvider "autopep8") autopep8
    ++ stdenv.lib.optional (withProvider "mccabe") mccabe
    ++ stdenv.lib.optional (withProvider "pycodestyle") pycodestyle
    ++ stdenv.lib.optional (withProvider "pydocstyle") pydocstyle
    ++ stdenv.lib.optional (withProvider "pyflakes") pyflakes
    ++ stdenv.lib.optional (withProvider "pylint") pylint
    ++ stdenv.lib.optional (withProvider "rope") rope
    ++ stdenv.lib.optional (withProvider "yapf") yapf
    ++ stdenv.lib.optional isPy27 configparser
    ++ stdenv.lib.optionals (pythonOlder "3.2") [ backports_functools_lru_cache futures ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/palantir/python-language-server";
    description = "An implementation of the Language Server Protocol for Python";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
