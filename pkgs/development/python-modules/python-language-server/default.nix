{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, isPy27
, backports_functools_lru_cache ? null, configparser ? null, futures ? null, future, jedi, pluggy, python-jsonrpc-server, flake8
, pytestCheckHook, mock, pytestcov, coverage, setuptools, ujson, flaky
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
  version = "0.36.2";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "python-language-server";
    rev = version;
    sha256 = "07x6jr4z20jxn03bxblwc8vk0ywha492cgwfhj7q97nb5cm7kx0q";
  };

  postPatch = ''
    # Reading the changelog I don't expect an API break in pycodestyle and pyflakes
    substituteInPlace setup.py \
      --replace "pycodestyle>=2.6.0,<2.7.0" "pycodestyle>=2.6.0,<2.8.0" \
      --replace "pyflakes>=2.2.0,<2.3.0" "pyflakes>=2.2.0,<2.4.0"
  '';

  propagatedBuildInputs = [ setuptools jedi pluggy future python-jsonrpc-server ujson ]
    ++ lib.optional (withProvider "autopep8") autopep8
    ++ lib.optional (withProvider "mccabe") mccabe
    ++ lib.optional (withProvider "pycodestyle") pycodestyle
    ++ lib.optional (withProvider "pydocstyle") pydocstyle
    ++ lib.optional (withProvider "pyflakes") pyflakes
    ++ lib.optional (withProvider "pylint") pylint
    ++ lib.optional (withProvider "rope") rope
    ++ lib.optional (withProvider "yapf") yapf
    ++ lib.optional isPy27 configparser
    ++ lib.optionals (pythonOlder "3.2") [ backports_functools_lru_cache futures ];

  # The tests require all the providers, disable otherwise.
  doCheck = providers == ["*"];

  checkInputs = [
    pytestCheckHook mock pytestcov coverage flaky
    # Do not propagate flake8 or it will enable pyflakes implicitly
    flake8
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
    "test_symbols"
  ] ++ lib.optional isPy27 "test_flake8_lint";

  meta = with lib; {
    homepage = "https://github.com/palantir/python-language-server";
    description = "An implementation of the Language Server Protocol for Python";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
