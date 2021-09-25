{ lib, buildPythonPackage, fetchPypi, pythonOlder
, mock, pytest, pytest-runner
, configparser, enum34, mccabe, pycodestyle, pyflakes, functools32, typing ? null, importlib-metadata
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "3.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07528381786f2a6237b061f6e96610a4167b226cb926e2aa2b6b1d78057c576b";
  };

  checkInputs = [ pytest mock pytest-runner ];
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
