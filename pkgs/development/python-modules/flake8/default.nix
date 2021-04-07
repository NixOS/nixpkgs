{ lib, buildPythonPackage, fetchPypi, pythonOlder
, mock, pytest, pytestrunner
, configparser, enum34, mccabe, pycodestyle, pyflakes, functools32, typing ? null, importlib-metadata
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "3.9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "78873e372b12b093da7b5e5ed302e8ad9e988b38b063b61ad937f26ca58fc5f0";
  };

  checkInputs = [ pytest mock pytestrunner ];
  propagatedBuildInputs = [ pyflakes pycodestyle mccabe ]
    ++ lib.optionals (pythonOlder "3.2") [ configparser functools32 ]
    ++ lib.optionals (pythonOlder "3.4") [ enum34 ]
    ++ lib.optionals (pythonOlder "3.5") [ typing ]
    ++ lib.optionals (pythonOlder "3.8") [ importlib-metadata ];

  # fixtures fail to initialize correctly
  checkPhase = ''
    py.test tests --ignore=tests/integration/test_checker.py
  '';

  meta = with lib; {
    description = "Code checking using pep8 and pyflakes";
    homepage = "https://pypi.python.org/pypi/flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
