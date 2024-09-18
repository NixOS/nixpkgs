{
  lib,
  buildPythonPackage,
  fetchPypi,
  pythonOlder,

  # runtime
  editables,
  packaging,
  pathspec,
  pluggy,
  tomli,
  trove-classifiers,

  # tests
  build,
  python,
  requests,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "hatchling";
  version = "1.25.0";
  format = "pyproject";
  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-cGRjGlEmELUiUKTT/xvYFVHW0UMcTre3LnNN9sdPQmI=";
  };

  # listed in backend/pyproject.toml
  propagatedBuildInputs = [
    editables
    packaging
    pathspec
    pluggy
    trove-classifiers
  ] ++ lib.optionals (pythonOlder "3.11") [ tomli ];

  pythonImportsCheck = [
    "hatchling"
    "hatchling.build"
  ];

  # tries to fetch packages from the internet
  doCheck = false;

  # listed in /backend/tests/downstream/requirements.txt
  nativeCheckInputs = [
    build
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
    mainProgram = "hatchling";
    homepage = "https://hatch.pypa.io/latest/";
    changelog = "https://github.com/pypa/hatch/releases/tag/hatchling-v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [
      hexa
      ofek
    ];
  };
}
