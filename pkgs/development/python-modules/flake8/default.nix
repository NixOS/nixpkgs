{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, configparser
, enum34
, mccabe
, pycodestyle
, pyflakes
, functools32
, typing
, importlib-metadata
, mock
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "flake8";
  version = "4.0.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "03c7mnk34wfz7a0m5zq0273y94awz69fy5iww8alh4a4v96h6vl0";
  };

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pyflakes >= 2.3.0, < 2.4.0" "pyflakes >= 2.3.0, < 2.5.0"
  '';

  propagatedBuildInputs = [
    pyflakes
    pycodestyle
    mccabe
  ] ++ lib.optionals (pythonOlder "3.2") [
    configparser
    functools32
  ] ++ lib.optionals (pythonOlder "3.4") [
    enum34
  ] ++ lib.optionals (pythonOlder "3.5") [
    typing
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  # Tests fail on Python 3.7 due to importlib using a deprecated interface
  doCheck = !(pythonOlder "3.8");

  checkInputs = [
    mock
    pytestCheckHook
  ];

  disabled = pythonOlder "3.6";

  meta = with lib; {
    description = "Flake8 is a wrapper around pyflakes, pycodestyle and mccabe.";
    homepage = "https://github.com/pycqa/flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
