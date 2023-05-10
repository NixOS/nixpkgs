{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, python
, pythonOlder
, typing-extensions
, packaging
, setuptools
# Test inputs
, pytest
, snapshottest
}:

buildPythonPackage rec {
  pname = "htmltools";
  version = "0.2.1";
  format = "setuptools";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "rstudio";
    repo = "py-htmltools";
    rev = "v${version}";
    hash = "sha256-QH8DPQBmhCOsUY6AE7K/6o9N8rvh45SbwauTSEdzcWk=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    typing-extensions
    packaging
  ];

  nativeCheckInputs = [
    pytest
    snapshottest
  ];

  checkPhase = ''
    runHook preCheck
    pytest tests/
    runHook postCheck
  '';

  doCheck = true;

  pythonImportsCheck = [ "htmltools" ];

  meta = with lib; {
    homepage = "https://github.com/rstudio/py-htmltools";
    changelog = "https://github.com/rstudio/py-htmltools/blob/main/CHANGELOG.md";
    description = "Tools for creating, manipulating, and writing HTML from Python.";
    license = licenses.mit;
    maintainers = with maintainers; [ nviets ];
    platforms = platforms.unix;
  };
}

