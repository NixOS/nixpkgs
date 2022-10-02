{ lib
, buildPythonPackage
, docutils
, fetchFromGitHub
, importlib-metadata
, mock
, poetry-core
, pydantic
, pytest-mock
, pytestCheckHook
, pythonOlder
, types-docutils
, typing-extensions
}:

buildPythonPackage rec {
  pname = "rstcheck-core";
  version = "1.0.2";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rstcheck";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XNr+prK9VDP66ZaFvh3Qrx+eJs6mnVO8lvoMC/qrCLs=";
  };

  nativeBuildInputs = [
    poetry-core
  ];

  propagatedBuildInputs = [
    docutils
    importlib-metadata
    pydantic
    types-docutils
    typing-extensions
  ];

  checkInputs = [
    mock
    pytest-mock
    pytestCheckHook
  ];

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'types-docutils = ">=0.18, <0.19"' 'types-docutils = ">=0.18"' \
      --replace 'docutils = ">=0.7, <0.19"' 'docutils = ">=0.7"'
  '';

  pythonImportsCheck = [
    "rstcheck_core"
  ];

  meta = with lib; {
    description = "Library for checking syntax of reStructuredText";
    homepage = "https://github.com/rstcheck/rstcheck-core";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
