{ lib
, appdirs
, buildPythonPackage
, click
, diskcache
, fetchPypi
, jinja2
, jsonschema
, pytestCheckHook
, pythonOlder
, pyyaml
, setuptools-scm
, yamllint
}:

buildPythonPackage rec {
  pname = "glean-parser";
  version = "10.0.3";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    pname = "glean_parser";
    inherit version;
    hash = "sha256-1XNZYp0pX57lcAaKKEaWaJLj/ttyIlnsvNjMN20pm1E=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "pytest-runner" "" \
      --replace "MarkupSafe>=1.1.1,<=2.0.1" "MarkupSafe>=1.1.1"
  '';

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    appdirs
    click
    diskcache
    jinja2
    jsonschema
    pyyaml
    yamllint
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  disabledTests = [
    # Network access
    "test_validate_ping"
    # Fails since yamllint 1.27.x
    "test_yaml_lint"
  ];

  pythonImportsCheck = [
    "glean_parser"
  ];

  meta = with lib; {
    description = "Tools for parsing the metadata for Mozilla's glean telemetry SDK";
    homepage = "https://github.com/mozilla/glean_parser";
    changelog = "https://github.com/mozilla/glean_parser/blob/v${version}/CHANGELOG.md";
    license = licenses.mpl20;
    maintainers = with maintainers; [];
  };
}
