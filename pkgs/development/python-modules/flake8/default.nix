{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, mccabe
, pycodestyle
, pyflakes
, importlib-metadata
, pythonAtLeast
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "5.0.4";

  disabled = pythonOlder "3.6";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "flake8";
    rev = version;
    hash = "sha256-Os8HIoM07/iOBMm+0WxdQj32pJJOJ8mkh+yLHpqkLXg=";
  };

  propagatedBuildInputs = [
    mccabe
    pycodestyle
    pyflakes
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # Tests fail on Python 3.7 due to importlib using a deprecated interface
  doCheck = pythonAtLeast "3.7";

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Flake8 is a wrapper around pyflakes, pycodestyle and mccabe.";
    homepage = "https://github.com/pycqa/flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ dotlambda ];
  };
}
