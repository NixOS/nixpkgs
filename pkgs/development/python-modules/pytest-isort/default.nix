{ lib
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
, importlib-metadata
, isort
, poetry-core
, pytest
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pytest-isort";
  version = "3.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "stephrdev";
    repo = pname;
    rev = version;
    hash = "sha256-gbEO3HBDeZ+nUACzpeV6iVuCdNHS5956wFzIYkbam+M=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    isort
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  checkInputs = [
    pytestCheckHook
  ];

  patches = [
    # Can be removed with the next release, https://github.com/stephrdev/pytest-isort/pull/44
    (fetchpatch {
      name = "switch-to-poetry-core.patch";
      url = "https://github.com/stephrdev/pytest-isort/commit/f17ed2d294ae90e415d051e1c720982e3dd01bff.patch";
      sha256 = "sha256-PiOs0c61BNx/tZN11DYblOd7tNzGthNnlkmYMTI9v18=";
    })
  ];

  pythonImportsCheck = [
    "pytest_isort"
  ];

  meta = with lib; {
    description = "Pytest plugin to perform isort checks (import ordering)";
    homepage = "https://github.com/moccu/pytest-isort/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
  };
}
