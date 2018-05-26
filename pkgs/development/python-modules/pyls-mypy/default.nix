{ lib, buildPythonPackage, fetchFromGitHub, fetchpatch
, future, python-language-server, mypy, configparser
, pytest, mock, isPy3k, pytestcov, coverage
}:

buildPythonPackage rec {
  pname = "pyls-mypy";
  version = "0.1.2";

  src = fetchFromGitHub {
    owner = "tomv564";
    repo = "pyls-mypy";
    rev = version;
    sha256 = "0wa038a8a8yj3wmrc7q909nj4b5d3lq70ysbw7rpsnyb0x06m826";
  };

  disabled = !isPy3k;

  patches = [
    # also part of https://github.com/tomv564/pyls-mypy/pull/10
    (fetchpatch {
      url = "https://github.com/Mic92/pyls-mypy/commit/4c727120d2cbd8bf2825e1491cd55175f03266d2.patch";
      sha256 = "1dgn5z742swpxwknmgvm65jpxq9zwzhggw4nl6ys7yw8r49kqgrl";
    })
  ];

  checkPhase = ''
    HOME=$TEMPDIR pytest
  '';

  checkInputs = [ pytest mock pytestcov coverage ];

  propagatedBuildInputs = [
    mypy python-language-server future configparser
  ];

  meta = with lib; {
    homepage = https://github.com/palantir/python-language-server;
    description = "An implementation of the Language Server Protocol for Python";
    license = licenses.mit;
    maintainers = [ maintainers.mic92 ];
  };
}
