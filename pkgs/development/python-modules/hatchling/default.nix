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
  version = "1.0.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "d235a5fa8aff89e8d9d6d4033594aa4c3bc00ec5e31d3e80c153bfcf951b4f98";
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
