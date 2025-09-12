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
  version = "17.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "glean_parser";
    inherit version;
    hash = "sha256-9w+0SWQ2Bo+B73hgKaGzafYa4vkyfusvpQM126We4hQ=";
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
