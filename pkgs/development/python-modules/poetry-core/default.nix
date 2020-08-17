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
  version = "1.0.0a9";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
    sha256 = "1ln47x1bc1yvhdfwfnkqx4d2j7988a59v8vmcriw14whfgzfki75";
  };

  # avoid mass-rebuild of python packages
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "^1.7.0" "^1.6.0"
  '';

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
  disabledTests = [ "default_with_excluded_data" ];

  pythonImportsCheck = [ "poetry.core" ];

  meta = with lib; {
    description = "Core utilities for Poetry";
    homepage = "https://github.com/python-poetry/poetry-core/";
    license = licenses.mit;
    maintainers = with maintainers; [ jonringer ];
  };
}
