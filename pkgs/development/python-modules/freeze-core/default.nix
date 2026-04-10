{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  cx-logging,
  distutils,
  filelock,

  # tests
  pytest-mock,
  pytestCheckHook,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "freeze-core";
  version = "0.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "marcelotduarte";
    repo = "freeze-core";
    tag = finalAttrs.version;
    hash = "sha256-88AODiBvIPq51l1rU+mshGknQk+3qoiR7I5mfNfNv50=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=82.0" "setuptools"
  '';

  build-system = [
    setuptools
    cx-logging
  ];

  dependencies = [
    distutils # needed to compile
    filelock
  ];

  pythonImportsCheck = [
    "freeze_core"
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Core dependency for cx_Freeze";
    changelog = "https://github.com/marcelotduarte/freeze-core/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sigmanificient ];
  };
})
