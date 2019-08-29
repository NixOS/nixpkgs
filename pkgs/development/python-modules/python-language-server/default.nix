{ stdenv, buildPythonPackage, fetchFromGitHub, pythonOlder, isPy27
, backports_functools_lru_cache, configparser, futures, future, jedi, pluggy, python-jsonrpc-server
, pytest, mock, pytestcov, coverage
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
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "python-language-server";
    rev = version;
    sha256 = "0xa0zw7hlfqqa305ic4csgfmlbxhklb5xzx72mfkcz8gcc0f5qwd";
  };

  # The tests require all the providers, disable otherwise.
  doCheck = providers == ["*"];

  checkInputs = [
    pytest mock pytestcov coverage
    # rope is technically a dependency, but we don't add it by default since we
    # already have jedi, which is the preferred option
    rope
  ];

  checkPhase = ''
    HOME=$TEMPDIR pytest
  '';

  propagatedBuildInputs = [ jedi pluggy future python-jsonrpc-server ]
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
    homepage = https://github.com/palantir/python-language-server;
    description = "An implementation of the Language Server Protocol for Python";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
