{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  formulaic,
  frozendict,
  click,
  num2words,
  numpy,
  scipy,
  pandas,
  nibabel,
  bids-validator,
  sqlalchemy,
  universal-pathlib,
  pytestCheckHook,
  versioneer,
}:

buildPythonPackage (finalAttrs: {
  pname = "pybids";
  version = "0.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bids-standard";
    repo = "pybids";
    tag = finalAttrs.version;
    hash = "sha256-hbisFgi8Cs0BnTkytrBDPMIHO5sy2O3oJSB0FvOD9GY=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'
  '';

  pythonRelaxDeps = [
    "formulaic"
    "sqlalchemy"
  ];

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    bids-validator
    click
    formulaic
    frozendict
    nibabel
    num2words
    numpy
    pandas
    scipy
    sqlalchemy
    universal-pathlib
  ];

  pythonImportsCheck = [ "bids" ];

  nativeCheckInputs = [ pytestCheckHook ];

  disabledTestPaths = [
    # Could not connect to the endpoint URL
    "src/bids/layout/tests/test_remote_bids.py"
  ];

  disabledTests = [
    # Regression associated with formulaic >= 0.6.0
    # (see https://github.com/bids-standard/pybids/issues/1000)
    "test_split"
    #  ValueError: Failed to load BIDS schema...
    "test_schema_version_parameter"
    "test_entity_parsing_version_differences"
    "test_motion_datatype_evolution"
    "test_schema_version_metadata_differences"
  ];

  meta = {
    description = "Python tools for querying and manipulating BIDS datasets";
    homepage = "https://github.com/bids-standard/pybids";
    changelog = "https://github.com/bids-standard/pybids/blob/${finalAttrs.src.tag}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
    mainProgram = "pybids";
  };
})
