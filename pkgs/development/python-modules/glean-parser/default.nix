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
  pythonOlder,
  pyyaml,
  setuptools,
  setuptools-scm,
  yamllint,
}:

buildPythonPackage rec {
  pname = "glean-parser";
  version = "14.1.2";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "glean_parser";
    inherit version;
    hash = "sha256-OL59Tg+rD4M0DjQnkU4IqGMcf6sIioxg6bVDyrbqgww=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" "" \
      --replace "MarkupSafe>=1.1.1,<=2.0.1" "MarkupSafe>=1.1.1"
  '';

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    appdirs
    click
    diskcache
    jinja2
    jsonschema
    pyyaml
    setuptools
    yamllint
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

  meta = with lib; {
    description = "Tools for parsing the metadata for Mozilla's glean telemetry SDK";
    mainProgram = "glean_parser";
    homepage = "https://github.com/mozilla/glean_parser";
    changelog = "https://github.com/mozilla/glean_parser/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
