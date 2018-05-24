{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, isPy27
, configparser, futures, future, jedi, pluggy
, pytest, mock, pytestcov, coverage
# The following packages are optional and
# can be overwritten with null as your liking.
# This also requires to disable tests.
, rope ? null
, mccabe ? null
, pyflakes ? null
, pycodestyle ? null
, autopep8 ? null
, yapf ? null
, pydocstyle ? null
}:

buildPythonPackage rec {
  pname = "python-language-server";
  version = "0.18.0";

  src = fetchFromGitHub {
    owner = "palantir";
    repo = "python-language-server";
    rev = version;
    sha256 = "0ig34bc0qm6gdj8xakmm3877lmf8ms7qg0xj8hay9gpgf8cz894s";
  };

  checkInputs = [
    pytest mock pytestcov coverage
    # rope is technically a dependency, but we don't add it by default since we
    # already have jedi, which is the preferred option
    rope
  ];
  checkPhase = ''
    HOME=$TEMPDIR pytest
  '';

  propagatedBuildInputs = [
    jedi pluggy mccabe pyflakes pycodestyle yapf pydocstyle future autopep8
  ] ++ lib.optional (isPy27) [ configparser ]
    ++ lib.optional (pythonOlder "3.2") [ futures ];

  meta = with lib; {
    homepage = https://github.com/palantir/python-language-server;
    description = "An implementation of the Language Server Protocol for Python";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
