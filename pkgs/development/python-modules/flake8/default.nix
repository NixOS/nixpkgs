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
  version = "6.0.0";

  disabled = pythonOlder "3.8";

  format = "setuptools";

  src = fetchFromGitHub {
    owner = "PyCQA";
    repo = "flake8";
    rev = version;
    hash = "sha256-dN9LlLpQ/ZoVIFrAQ1NxMvsHqWsgdJVLUIAFwkheEL4=";
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
