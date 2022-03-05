{ lib
, buildPythonPackage
, fetchFromGitHub
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
, toml
, virtualenv
}:

let
  pname = "hatchling";
  version = "0.18.0";
in
buildPythonPackage {
  inherit pname version;
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "ofek";
    repo = "hatch";
    rev = "${pname}-v${version}";
    hash = "sha256-kCaEAM0cY1yQcuHfvnaLs3smN9MKATjrrQTXpCfGmWc=";
  };

  prePatch = ''
    cd backend
  '';

  # listed in backend/src/hatchling/ouroboros.py
  propagatedBuildInputs = [
    editables
    packaging
    pathspec
    pluggy
    tomli
  ] ++ lib.optionals (pythonOlder "3.8") [
    importlib-metadata
  ];

  pythonImportsCheck = [
    "hatchling"
  ];

  # tries to fetch packages from the internet
  doCheck = false;

  # listed in /backend/tests/downstream/requirements.txt
  checkInputs = [
    build
    packaging
    requests
    toml
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
    homepage = "https://ofek.dev/hatch/latest/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
