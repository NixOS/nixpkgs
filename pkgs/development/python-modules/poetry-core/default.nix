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
  version = "1.0.2";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "python-poetry";
    repo = pname;
    rev = version;
    sha256 = "sha256-OE6oc/3HYrMmgPnINxvSZ27m8YeZk5Gnn9ok8GlSIZ0=";
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
