{ blinker, buildPythonPackage, fetchFromGitHub, lib, isPy27, six, mock, pytest
, webtest, pytest-cov, pytest-django, pytest-pythonpath, flake8, sqlalchemy
, flask_sqlalchemy, peewee }:

buildPythonPackage rec {
  pname = "nplusone";
  version = "1.0.0";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "jmcarp";
    repo = "nplusone";
    rev = "v${version}";
    sha256 = "0qdwpvvg7dzmksz3vqkvb27n52lq5sa8i06m7idnj5xk2dgjkdxg";
  };

  # The tests assume the source code is in an nplusone/ directory. When using
  # the Nix sandbox, it will be in a source/ directory instead, making the
  # tests fail.
  prePatch = ''
    substituteInPlace tests/conftest.py \
      --replace nplusone/tests/conftest source/tests/conftest
  '';

  checkPhase = ''
    pytest tests/
  '';

  propagatedBuildInputs = [ six blinker ];
  checkInputs = [
    mock
    pytest
    webtest
    pytest-cov
    pytest-django
    pytest-pythonpath
    flake8
    sqlalchemy
    flask_sqlalchemy
    peewee
  ];

  meta = with lib; {
    description = "Detecting the n+1 queries problem in Python";
    homepage = "https://github.com/jmcarp/nplusone";
    maintainers = with maintainers; [ cript0nauta ];
    license = licenses.mit;
  };
}
