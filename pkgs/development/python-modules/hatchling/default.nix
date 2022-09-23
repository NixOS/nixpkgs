{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder

# runtime
, editables
, importlib-metadata # < 3.8
, packaging
, pathspec
, pluggy
, tomli

# tests
, build
, python
, requests
, virtualenv
}:

let
  pname = "hatchling";
  version = "1.8.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-pPmC/coHF9jEa/57UBMC+QqvKlMChF1VC0nIc5aB/rI=";
  };

  # listed in backend/src/hatchling/ouroboros.py
  propagatedBuildInputs = [
    editables
    packaging
    pathspec
    pluggy
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ] ++ lib.optionals (pythonOlder "3.11") [
    tomli
  ];

  pythonImportsCheck = [
    "hatchling"
    "hatchling.build"
  ];

  # tries to fetch packages from the internet
  doCheck = false;

  # listed in /backend/tests/downstream/requirements.txt
  checkInputs = [
    build
    packaging
    requests
    virtualenv
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/downstream/integrate.py
    runHook postCheck
  '';

  meta = with lib; {
    description = "Modern, extensible Python build backend";
    homepage = "https://hatch.pypa.io/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ofek ];
  };
}
