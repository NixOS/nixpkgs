{ lib
, stdenv
, pythonOlder
, buildPythonPackage
, fetchFromGitHub

# setup requires
, setuptools

# install requires
, rsconnect-python
, notebook
, nbformat
, nbconvert
, six
, ipython

# checks require
, pytest
, black
, mock
, python
}:

buildPythonPackage rec {
  pname = "rsconnect-jupyter";
  version = "1.8.0";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "rsconnect-jupyter";
    rev = "${version}";
    hash = "sha256-3x4j9Ud6H0eNgc9bhwbQyBRZgCBb7Fgm0lpJUc1EUSE=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    rsconnect-python
    notebook
    nbformat
    nbconvert
    six
    ipython
  ];

  nativeCheckInputs = [
    pytest
    black
    mock
  ];

  # Disable test_managers which import asyncmock, now defunct
  # can reenable once upstream updates
  checkPhase = ''
    runHook preCheck
    pytest tests/ --ignore=tests/test_managers.py
    runHook postCheck
  '';

  doCheck = true;

  pythonImportsCheck = [ "rsconnect_jupyter" ];

  meta = with lib; {
    homepage = "https://github.com/rstudio/py-htmltools";
    changelog = "https://github.com/rstudio/py-htmltools/blob/main/CHANGELOG.md";
    description = "Tools for creating, manipulating, and writing HTML from Python.";
    license = licenses.mit;
    maintainers = with maintainers; [ nviets ];
    platforms = platforms.unix;
  };
}

