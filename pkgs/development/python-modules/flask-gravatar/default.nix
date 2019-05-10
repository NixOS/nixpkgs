{ stdenv
, buildPythonPackage
, python
, fetchPypi
, flask
, pytest
, pytest-runner
, pytestcov
, pytestpep8
, pydocstyle
, isort
, check-manifest
}:

buildPythonPackage rec {
  pname = "Flask-Gravatar";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1qb2ylirjajdqsmldhwfdhf8i86k7vlh3y4gnqfqj4n6q8qmyrk0";
  };

  buildInputs = [
    pytest
    pytest-runner
    pytestcov
    pytestpep8
    pydocstyle
    isort
    check-manifest
  ];

  doCheck = false;

  propagatedBuildInputs = [
    flask
  ];

  meta = with stdenv.lib; {
    description = "This is small and simple integration gravatar into flask";
    license = licenses.bsd2;
    maintainers = with maintainers; [ kuznero ];
    homepage = https://github.com/zzzsochi/Flask-Gravatar;
  };
}
