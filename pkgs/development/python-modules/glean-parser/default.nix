{
  lib,
  appdirs,
  buildPythonPackage,
  click,
  diskcache,
  fetchPypi,
  jinja2,
  jsonschema,
  pytestCheckHook,
  pyyaml,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "glean-parser";
  version = "14.5.1";
  pyproject = true;

  src = fetchPypi {
    pname = "glean_parser";
    inherit version;
    hash = "sha256-G01gBwBN3oQ5yvobaLiJYrhjjLfninVjSYuXLsJg1DU=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace-fail "pytest-runner" ""
  '';

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    appdirs
    click
    diskcache
    jinja2
    jsonschema
    pyyaml
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # Network access
    "test_validate_ping"
    "test_logging"
    # Fails since yamllint 1.27.x
    "test_yaml_lint"
  ];

  pythonImportsCheck = [ "glean_parser" ];

  meta = {
    description = "Tools for parsing the metadata for Mozilla's glean telemetry SDK";
    mainProgram = "glean_parser";
    homepage = "https://github.com/mozilla/glean_parser";
    changelog = "https://github.com/mozilla/glean_parser/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mpl20;
    maintainers = [ ];
  };
}
