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

buildPythonPackage (finalAttrs: {
  pname = "hatchling";
  version = "1.30.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-7uT9RTV/cuuz16QuXXLPteKe1CbXnog2KIkmxCWNXy4=";
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
    changelog = "https://github.com/pypa/hatch/releases/tag/hatchling-v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      hexa
      ofek
    ];
  };
})
