{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  formulaic,
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

buildPythonPackage rec {
  pname = "pybids";
  version = "0.18.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "bids-standard";
    repo = "pybids";
    rev = version;
    hash = "sha256-nSBc4vhkCdRo7CNBwvJreCiwoxJK6ztyI5gvcpzYZ/Y=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'dynamic = ["version"]' 'version = "${version}"'
  '';

  pythonRelaxDeps = [
    "formulaic"
    "sqlalchemy"
  ];

  build-system = [
    setuptools
    versioneer
  ] ++ versioneer.optional-dependencies.toml;

  dependencies = [
    bids-validator
    click
    formulaic
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
  ];

  meta = {
    description = "Python tools for querying and manipulating BIDS datasets";
    homepage = "https://github.com/bids-standard/pybids";
    changelog = "https://github.com/bids-standard/pybids/blob/${version}/CHANGELOG.rst";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wegank ];
    mainProgram = "pybids";
  };
}
