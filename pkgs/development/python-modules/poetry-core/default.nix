{ lib, buildPythonPackage, fetchFromGitHub, pythonOlder, isPy27
, importlib-metadata
, intreehooks
, isort
, pathlib2
, pep517
, pytest-mock
, pytestCheckHook
, tomlkit
, typing
, virtualenv
}:

buildPythonPackage rec {
  pname = "poetry-core";
  version = "1.0.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
    sha256 = "02pqkwzbg43xz2zsw8q7m0sfkj8wbw07in83gy0bk0znhljhp0vw";
  };

  nativeBuildInputs = [
    intreehooks
  ];

  propagatedBuildInputs = lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals isPy27 [
    pathlib2
    typing
  ];

  checkInputs = [
    isort
    pep517
    pytest-mock
    pytestCheckHook
    tomlkit
    virtualenv
  ];

  # requires git history to work correctly
  disabledTests = [ "default_with_excluded_data" "default_src_with_excluded_data" ];

  pythonImportsCheck = [ "poetry.core" ];

  meta = with lib; {
    description = "Core utilities for Poetry";
    homepage = "https://github.com/python-poetry/poetry-core/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
