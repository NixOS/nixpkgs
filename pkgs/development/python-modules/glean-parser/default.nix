{
  lib,
  buildPythonPackage,
  click,
  diskcache,
  fetchPypi,
  hatchling,
  hatch-vcs,
  jinja2,
  jsonschema,
  platformdirs,
  pytestCheckHook,
  pyyaml,
}:

buildPythonPackage rec {
  pname = "glean-parser";
  version = "20.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "glean_parser";
    inherit version;
    hash = "sha256-CP7Dh8XSpoOkMVLWmUIAlG5vBpc8yQW3yHYX+y1XsMU=";
  };

  build-system = [
    hatchling
    hatch-vcs
  ];

  dependencies = [
    click
    diskcache
    jinja2
    jsonschema
    pyyaml
    platformdirs
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTestPaths = [
    # https://github.com/mozilla/glean_parser/pull/863
    "tests/test_metrics.py::test_expires"
    # https://github.com/mozilla/glean_parser/pull/872
    "tests/test_parser.py::test_expire_epoch_can_be_overriden"
    # https://github.com/mozilla/glean_parser/pull/873
    "tests/test_python_server.py::test_logging"
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
