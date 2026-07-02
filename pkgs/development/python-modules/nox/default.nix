{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  attrs,
  argcomplete,
  colorlog,
  dependency-groups,
  humanize,
  jinja2,
  packaging,
  tomli,

  # tests
  pytestCheckHook,
  writableTmpDirAsHomeHook,

  # passthru
  tox,
  uv,
  virtualenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "nox";
  version = "2026.04.10";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "wntrblm";
    repo = "nox";
    tag = finalAttrs.version;
    hash = "sha256-ArSA9I86hTKM+fkTdzOeheYVxpdjweMs2I0mUwR14sQ=";
  };

  build-system = [ hatchling ];

  dependencies = [
    argcomplete
    attrs
    colorlog
    dependency-groups
    humanize
    packaging
    virtualenv
  ];

  optional-dependencies = {
    tox-to-nox = [
      jinja2
      tox
    ];
    uv = [ uv ];
  };

  nativeCheckInputs = [
    pytestCheckHook
    writableTmpDirAsHomeHook
  ]
  ++ lib.flatten (builtins.attrValues finalAttrs.passthru.optional-dependencies);

  pythonImportsCheck = [ "nox" ];

  disabledTests = [
    # Assertion errors
    "test_uv"
    # Test requires network access
    "test_noxfile_script_mode_url_req"
    # Don't test CLi mode
    "test_noxfile_script_mode"
  ];

  disabledTestPaths = [
    # AttributeError: module 'tox.config' has...
    "tests/test_tox_to_nox.py"
  ];

  meta = {
    description = "Flexible test automation for Python";
    homepage = "https://nox.thea.codes/";
    changelog = "https://github.com/wntrblm/nox/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      doronbehar
      fab
    ];
  };
})
