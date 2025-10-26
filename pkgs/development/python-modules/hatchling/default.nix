{
  lib,
  buildPythonPackage,
  fetchPypi,

  # runtime
  editables,
  packaging,
  pathspec,
  pluggy,
  trove-classifiers,

  # tests
  build,
  python,
  requests,
  virtualenv,
}:

buildPythonPackage rec {
  pname = "hatchling";
  version = "1.28.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-TVCwKuzmiSuM0LPObILLIYWU0+xYNtvedb9BohqwBMg=";
  };

  # listed in backend/pyproject.toml
  dependencies = [
    editables
    packaging
    pathspec
    pluggy
    trove-classifiers
  ];

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
    export HOME=$(mktemp -d)
  '';

  checkPhase = ''
    runHook preCheck
    ${python.interpreter} tests/downstream/integrate.py
    runHook postCheck
  '';

  meta = {
    description = "Modern, extensible Python build backend";
    mainProgram = "hatchling";
    homepage = "https://hatch.pypa.io/latest/";
    changelog = "https://github.com/pypa/hatch/releases/tag/hatchling-v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hexa
      ofek
    ];
  };
}
