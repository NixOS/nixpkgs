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
  version = "3.9.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07528381786f2a6237b061f6e96610a4167b226cb926e2aa2b6b1d78057c576b";
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

  meta = with lib; {
    description = "Flake8 is a wrapper around pyflakes, pycodestyle and mccabe.";
    homepage = "https://github.com/pycqa/flake8";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
